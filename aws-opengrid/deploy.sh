#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}OpenGrid Deployment Script${NC}"
echo "================================"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not installed${NC}"
    echo "Please install AWS CLI: https://aws.amazon.com/cli/"
    exit 1
fi

# Check if jq is installed for JSON parsing
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Warning: jq is not installed. Install it for better output formatting${NC}"
fi

# Get CloudFront distribution ID from Terraform output
cd terraform
if [ ! -f "terraform.tfstate" ]; then
    echo -e "${RED}Error: terraform.tfstate not found${NC}"
    echo "Please run 'terraform apply' first to create the infrastructure"
    exit 1
fi

DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id 2>/dev/null)
BUCKET_NAME=$(terraform output -raw s3_bucket_name 2>/dev/null)

if [ -z "$DISTRIBUTION_ID" ] || [ -z "$BUCKET_NAME" ]; then
    echo -e "${RED}Error: Could not get CloudFront distribution ID or S3 bucket name${NC}"
    echo "Make sure Terraform has been applied successfully"
    exit 1
fi

cd ..

echo -e "${GREEN}Deploying to S3 bucket: ${BUCKET_NAME}${NC}"

# Sync website files to S3
aws s3 sync ./website/ s3://${BUCKET_NAME}/opengrid/ \
    --delete \
    --cache-control "public, max-age=3600" \
    --exclude ".DS_Store" \
    --exclude "*.swp"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Files uploaded successfully${NC}"
else
    echo -e "${RED}✗ Failed to upload files${NC}"
    exit 1
fi

echo -e "${GREEN}Creating CloudFront invalidation...${NC}"

# Invalidate CloudFront cache
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id ${DISTRIBUTION_ID} \
    --paths "/opengrid/*" \
    --query 'Invalidation.Id' \
    --output text)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ CloudFront invalidation created: ${INVALIDATION_ID}${NC}"
    echo -e "${YELLOW}Note: It may take a few minutes for the invalidation to complete${NC}"
else
    echo -e "${RED}✗ Failed to create invalidation${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Deployment complete!${NC}"
echo -e "Your website should be available at: ${GREEN}https://jonathanpoulter.com/opengrid${NC}"
echo ""
echo "To check invalidation status, run:"
echo "  aws cloudfront get-invalidation --distribution-id ${DISTRIBUTION_ID} --id ${INVALIDATION_ID}"
