# OpenGrid Website Deployment

This directory contains the configuration and website files for deploying a website to `jonathanpoulter.com/opengrid`.

📖 **For complete setup and deployment instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)**

## Quick Start

1. Configure ACM certificate ARN and authentication credentials in `terraform/terraform.tfvars`
2. Run `cd terraform && terraform init && terraform apply`
3. Run `./deploy.sh` to deploy the website

## 🔒 Password Protection

The website is **protected by HTTP Basic Authentication** by default. Visitors will be prompted for a username and password before accessing the site.

To configure authentication:
1. Edit `terraform/terraform.tfvars` 
2. Set `auth_username` and `auth_password` to your desired credentials
3. Run `terraform apply` to update the configuration

To disable password protection, set `enable_password_protection = false` in `terraform.tfvars`.

## Directory Structure

```
aws-opengrid/
├── website/           # Static website files
│   └── index.html    # Main page (placeholder - replace with your content)
├── terraform/        # AWS infrastructure configuration
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── deploy.sh         # Deployment script
├── DEPLOYMENT_GUIDE.md  # Complete deployment instructions
└── README.md         # This file
```

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (v1.0+)
- An AWS account with Route53 hosting the `jonathanpoulter.com` domain
- An ACM certificate for `jonathanpoulter.com` in us-east-1 region

## Setup

### 1. Configure AWS Infrastructure

The Terraform configuration creates:
- S3 bucket for static website hosting
- CloudFront distribution for CDN and HTTPS
- Route53 DNS records
- Lambda@Edge function for HTTP Basic Authentication (optional)

### 2. Deploy

```bash
# Navigate to the terraform directory
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# Deploy website files
cd ..
./deploy.sh
```

## Manual Deployment

If you prefer to deploy manually:

```bash
# Sync website files to S3
aws s3 sync ./website/ s3://jonathanpoulter-opengrid/ --delete

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"
```

## Updating the Website

1. Edit files in the `website/` directory
2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

## Notes

- The website will be accessible at `https://jonathanpoulter.com/opengrid`
- CloudFront caching is configured with a 1-hour default TTL
- SSL certificate must be in us-east-1 region for CloudFront

## Troubleshooting

- **DNS not resolving**: Wait up to 48 hours for DNS propagation
- **Certificate errors**: Ensure your ACM certificate includes `jonathanpoulter.com`
- **403 Forbidden**: Check S3 bucket policy and CloudFront origin settings
