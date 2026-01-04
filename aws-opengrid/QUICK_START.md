# Quick Start Guide for OpenGrid Deployment

This guide will help you deploy your website to `https://jonathanpoulter.com/opengrid` in just a few steps.

## Prerequisites Check

Before you begin, make sure you have:
- [ ] AWS CLI installed and configured
- [ ] Terraform installed (v1.0+)
- [ ] An SSL certificate for `jonathanpoulter.com` in AWS Certificate Manager (us-east-1)

## 5-Step Deployment

### Step 1: Get Your Certificate ARN

Find your certificate ARN in AWS Certificate Manager (us-east-1 region):
```bash
aws acm list-certificates --region us-east-1
```

Copy the CertificateArn value (looks like: `arn:aws:acm:us-east-1:123456789:certificate/abc-123`)

### Step 2: Configure Terraform

```bash
cd aws-opengrid/terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and configure:
```hcl
acm_certificate_arn = "arn:aws:acm:us-east-1:YOUR_ACCOUNT:certificate/YOUR_CERT_ID"

# Password protection (enabled by default)
enable_password_protection = true
auth_username = "admin"
auth_password = "your-secure-password"  # Change this!
```

🔒 **Important**: The website is password-protected by default. Choose a strong password!

### Step 3: Create AWS Infrastructure

```bash
terraform init
terraform plan  # Review what will be created
terraform apply # Type 'yes' to confirm
```

⏱️ This takes 15-20 minutes (CloudFront distribution creation)

### Step 4: Deploy Your Website

Replace the placeholder content in `aws-opengrid/website/index.html` with your actual website, then:

```bash
cd ..  # Back to aws-opengrid directory
./deploy.sh
```

### Step 5: Verify

Open your browser to: https://jonathanpoulter.com/opengrid

🎉 Done!

## Optional: Set Up Auto-Deployment

For automatic deployments when you push to GitHub:

1. Set up AWS IAM OIDC for GitHub Actions (see DEPLOYMENT_GUIDE.md)
2. Add these secrets to your GitHub repository:
   - `AWS_ROLE_ARN`
   - `CLOUDFRONT_DISTRIBUTION_ID`

After setup, every push to `main` that changes files in `aws-opengrid/website/` will automatically deploy.

## Need Help?

- **Full documentation**: See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- **Terraform issues**: Run `terraform plan` to see what's wrong
- **Website not loading**: Check CloudFront distribution status in AWS Console
- **Changes not appearing**: Run `./deploy.sh` to clear CloudFront cache

## Quick Commands

```bash
# Update website
cd aws-opengrid && ./deploy.sh

# Check infrastructure status
cd terraform && terraform show

# Destroy everything (careful!)
cd terraform && terraform destroy
```
