# OpenGrid Deployment Guide

Complete guide for deploying the OpenGrid website to jonathanpoulter.com/opengrid using AWS infrastructure.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Password Protection](#password-protection)
4. [Manual Deployment](#manual-deployment)
5. [Automated Deployment with GitHub Actions](#automated-deployment-with-github-actions)
6. [Updating the Website](#updating-the-website)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have:

- AWS CLI installed and configured
- Terraform installed (v1.0 or higher)
- An AWS account with appropriate permissions
- The domain `jonathanpoulter.com` managed in Route53
- An SSL/TLS certificate in AWS Certificate Manager (ACM) for `jonathanpoulter.com` in the `us-east-1` region

### Installing Prerequisites

**AWS CLI:**
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS credentials
aws configure
```

**Terraform:**
```bash
# macOS
brew install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

## Initial Setup

### Step 1: Create ACM Certificate

If you don't already have an SSL certificate for `jonathanpoulter.com`:

1. Go to AWS Certificate Manager in the `us-east-1` region
2. Request a public certificate
3. Add `jonathanpoulter.com` and `*.jonathanpoulter.com` as domain names
4. Choose DNS validation
5. Add the CNAME records to your Route53 hosted zone
6. Wait for the certificate to be validated and issued
7. Copy the certificate ARN (format: `arn:aws:acm:us-east-1:ACCOUNT_ID:certificate/CERTIFICATE_ID`)

### Step 2: Configure Terraform

1. Navigate to the terraform directory:
   ```bash
   cd aws-opengrid/terraform
   ```

2. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edit `terraform.tfvars` and configure your settings:
   ```hcl
   aws_region = "us-east-1"
   domain_name = "jonathanpoulter.com"
   subdomain = "opengrid"
   bucket_name = "jonathanpoulter-opengrid"
   acm_certificate_arn = "arn:aws:acm:us-east-1:ACCOUNT_ID:certificate/CERTIFICATE_ID"
   
   # Password protection settings
   enable_password_protection = true
   
   # Option 1: Use AWS Secrets Manager (recommended)
   secrets_manager_secret_name = "prod/login"
   
   # Option 2: Use variables (comment out secrets_manager_secret_name)
   # auth_username = "admin"
   # auth_password = "your-secure-password-here"
   ```

   🔒 **Security Note**: The website is protected by HTTP Basic Authentication by default. Using AWS Secrets Manager is recommended for production.

### Step 3: Initialize and Apply Terraform

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration (this will create AWS resources)
terraform apply
```

Terraform will create:
- S3 bucket for website hosting
- CloudFront distribution for CDN
- Route53 DNS records
- Lambda@Edge function for HTTP Basic Authentication (if enabled)

**Note:** CloudFront distribution creation can take 15-20 minutes.

### Step 4: Deploy the Website

After Terraform completes successfully:

```bash
cd ..  # Return to aws-opengrid directory
./deploy.sh
```

The website should now be available at: https://jonathanpoulter.com/opengrid

🔒 When you visit the site, you'll be prompted to enter the username and password you configured.

## Password Protection

The website uses **HTTP Basic Authentication** via Lambda@Edge to restrict access.

### How It Works

1. A Lambda@Edge function intercepts all requests to your CloudFront distribution
2. The function checks for valid authentication credentials
3. If credentials are missing or incorrect, visitors see a browser login prompt
4. Only authenticated users can access the website

### Configuration

Password protection can be configured in two ways:

**Option 1: AWS Secrets Manager (Recommended for Production)**

1. Create a secret in AWS Secrets Manager with JSON format:
   ```json
   {
     "username": "your-username",
     "password": "your-secure-password"
   }
   ```

2. In `terraform.tfvars`:
   ```hcl
   enable_password_protection = true
   secrets_manager_secret_name = "prod/login"
   ```

**Option 2: Terraform Variables (Simpler, for Development)**

```hcl
enable_password_protection = true
auth_username = "admin"
auth_password = "secure-password"  # Min 8 characters
```

**Note**: Terraform fetches credentials from Secrets Manager during `terraform apply` and embeds them in the Lambda@Edge function. Lambda@Edge cannot access Secrets Manager at runtime since it runs at CloudFront edge locations globally.

### Changing Credentials

**If using Secrets Manager:**
1. Update the secret value in AWS Secrets Manager
2. Run `terraform apply` to redeploy the Lambda function with new credentials
3. Wait 5-10 minutes for CloudFront to propagate changes

**If using Terraform variables:**
1. Edit `terraform.tfvars` with new credentials
2. Run `terraform apply` to update the Lambda function
3. Wait 5-10 minutes for CloudFront to deploy the updated Lambda@Edge function globally

**Note**: Lambda@Edge functions are replicated to AWS edge locations worldwide, so updates take a few minutes to propagate.

### Disabling Password Protection

To make the website publicly accessible:

1. Set `enable_password_protection = false` in `terraform.tfvars`
2. Run `terraform apply`
3. The Lambda@Edge function will be removed and the site will be accessible without authentication

### Security Considerations

- HTTP Basic Authentication sends credentials with every request (over HTTPS)
- **AWS Secrets Manager integration**: Credentials can be stored in Secrets Manager and fetched during deployment
- Credentials are marked as sensitive in Terraform (not shown in logs)
- Lambda@Edge embeds credentials in the function (retrieved during `terraform apply`)
- For production use with highly sensitive data, consider:
  - Using AWS Secrets Manager (now supported via `secrets_manager_secret_name`)
  - Implementing more robust authentication (OAuth, SAML, etc.)
  - Adding IP allowlisting via CloudFront or AWS WAF
  - Rotating credentials regularly

## Manual Deployment

To manually deploy website updates:

```bash
cd aws-opengrid

# Upload files to S3
aws s3 sync ./website/ s3://jonathanpoulter-opengrid/opengrid/ --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation \
  --distribution-id YOUR_DISTRIBUTION_ID \
  --paths "/opengrid/*"
```

Get your distribution ID:
```bash
cd terraform
terraform output cloudfront_distribution_id
```

## Automated Deployment with GitHub Actions

For automatic deployments on git push, set up GitHub Actions:

### Step 1: Create AWS IAM Role for GitHub Actions

Create an IAM role that GitHub Actions can assume using OIDC:

1. Create an OIDC provider in IAM:
   - Provider URL: `https://token.actions.githubusercontent.com`
   - Audience: `sts.amazonaws.com`

2. Create an IAM role with the following trust policy:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
         },
         "Action": "sts:AssumeRoleWithWebIdentity",
         "Condition": {
           "StringEquals": {
             "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
           },
           "StringLike": {
             "token.actions.githubusercontent.com:sub": "repo:poulter7/nix-config:*"
           }
         }
       }
     ]
   }
   ```

3. Attach the following permissions policy:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:PutObject",
           "s3:GetObject",
           "s3:DeleteObject",
           "s3:ListBucket"
         ],
         "Resource": [
           "arn:aws:s3:::jonathanpoulter-opengrid",
           "arn:aws:s3:::jonathanpoulter-opengrid/*"
         ]
       },
       {
         "Effect": "Allow",
         "Action": [
           "cloudfront:CreateInvalidation",
           "cloudfront:GetInvalidation"
         ],
         "Resource": "arn:aws:cloudfront::ACCOUNT_ID:distribution/DISTRIBUTION_ID"
       }
     ]
   }
   ```

### Step 2: Configure GitHub Secrets

Add the following secrets to your GitHub repository:

- `AWS_ROLE_ARN`: ARN of the IAM role created above
- `CLOUDFRONT_DISTRIBUTION_ID`: Your CloudFront distribution ID

To add secrets:
1. Go to your GitHub repository
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"

### Step 3: Test Automated Deployment

Once configured, any push to the `main` branch that modifies files in `aws-opengrid/website/` will trigger an automatic deployment.

You can also manually trigger deployment:
1. Go to Actions tab in GitHub
2. Select "Deploy OpenGrid to AWS"
3. Click "Run workflow"

## Updating the Website

### Method 1: Using the Deploy Script (Recommended)

1. Update files in `aws-opengrid/website/`
2. Run the deployment script:
   ```bash
   cd aws-opengrid
   ./deploy.sh
   ```

### Method 2: Using GitHub Actions

1. Update files in `aws-opengrid/website/`
2. Commit and push to main branch:
   ```bash
   git add aws-opengrid/website/
   git commit -m "Update website content"
   git push
   ```

The GitHub Action will automatically deploy your changes.

### Replacing the Placeholder Content

The current `website/index.html` is a placeholder. To deploy your actual website:

1. Replace `aws-opengrid/website/index.html` with your content
2. Add any additional files (CSS, JavaScript, images) to the `website/` directory
3. Deploy using one of the methods above

## Troubleshooting

### Certificate Errors

**Problem:** SSL/TLS certificate errors when accessing the site

**Solution:**
- Ensure the ACM certificate is in the `us-east-1` region (CloudFront requirement)
- Verify the certificate includes `jonathanpoulter.com`
- Wait for certificate validation to complete (can take a few minutes to hours)

### DNS Not Resolving

**Problem:** Domain doesn't resolve or shows errors

**Solution:**
- Wait up to 48 hours for DNS propagation
- Verify Route53 hosted zone exists for `jonathanpoulter.com`
- Check that name servers in your domain registrar match Route53 name servers
- Use `dig jonathanpoulter.com` or `nslookup jonathanpoulter.com` to test DNS

### 403 Forbidden Error

**Problem:** Accessing the site returns 403 Forbidden

**Solution:**
- Verify S3 bucket policy allows CloudFront access
- Check that index.html exists in the S3 bucket at `/opengrid/index.html`
- Ensure CloudFront distribution has the correct origin path
- Run `aws s3 ls s3://jonathanpoulter-opengrid/opengrid/` to verify files are uploaded

### CloudFront Caching Issues

**Problem:** Changes not appearing on the website

**Solution:**
- Create a CloudFront invalidation:
  ```bash
  aws cloudfront create-invalidation \
    --distribution-id YOUR_DISTRIBUTION_ID \
    --paths "/opengrid/*"
  ```
- Wait a few minutes for invalidation to complete
- Hard refresh your browser (Ctrl+Shift+R or Cmd+Shift+R)

### Terraform State Issues

**Problem:** Terraform errors about existing resources or state conflicts

**Solution:**
- If resources already exist, import them:
  ```bash
  terraform import aws_s3_bucket.opengrid jonathanpoulter-opengrid
  ```
- To start fresh (⚠️ destroys existing resources):
  ```bash
  terraform destroy
  terraform apply
  ```

### GitHub Actions Deployment Failures

**Problem:** GitHub Actions workflow fails

**Solution:**
- Check that AWS IAM role ARN is correct in secrets
- Verify IAM role has correct trust policy for GitHub OIDC
- Ensure IAM role has necessary S3 and CloudFront permissions
- Check workflow logs for specific error messages

## Additional Resources

- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions OIDC with AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)

## Cost Considerations

Estimated AWS costs for this setup:

- **S3 Storage:** ~$0.023/GB per month
- **CloudFront:** First 10 TB: $0.085/GB (data transfer)
- **Route53 Hosted Zone:** $0.50/month
- **Route53 Queries:** $0.40 per million queries

For a small personal website, expect costs under $5/month.

## Support

For issues or questions, please open an issue in the GitHub repository.
