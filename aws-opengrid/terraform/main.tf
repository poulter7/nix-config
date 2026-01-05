# S3 bucket for hosting the static website
resource "aws_s3_bucket" "opengrid" {
  bucket = var.bucket_name

  tags = {
    Name        = "OpenGrid Website"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Local values
locals {
  # AWS Managed Cache Policy: CachingOptimized
  # This policy is optimized for caching static content with support for compression
  cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "opengrid" {
  bucket = aws_s3_bucket.opengrid.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket public access settings - block public access since CloudFront uses OAC
resource "aws_s3_bucket_public_access_block" "opengrid" {
  bucket = aws_s3_bucket.opengrid.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy for CloudFront access
resource "aws_s3_bucket_policy" "opengrid" {
  bucket = aws_s3_bucket.opengrid.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.opengrid.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.opengrid.arn
          }
        }
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.opengrid
  ]
}

# S3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "opengrid" {
  bucket = aws_s3_bucket.opengrid.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "opengrid" {
  name                              = "opengrid-oac"
  description                       = "OAC for OpenGrid S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "opengrid" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "OpenGrid CDN"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases             = ["opengrid.${var.domain_name}"]

  origin {
    domain_name              = aws_s3_bucket.opengrid.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.opengrid.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    
    cache_policy_id = local.cache_policy_id

    # Attach Lambda@Edge for authentication if enabled
    dynamic "lambda_function_association" {
      for_each = var.enable_password_protection ? [1] : []
      content {
        event_type   = "viewer-request"
        lambda_arn   = aws_lambda_function.auth[0].qualified_arn
        include_body = false
      }
    }
  }

  # Cache behavior for /opengrid path
  ordered_cache_behavior {
    path_pattern           = "/opengrid/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    
    cache_policy_id = local.cache_policy_id

    # Attach Lambda@Edge for authentication if enabled
    dynamic "lambda_function_association" {
      for_each = var.enable_password_protection ? [1] : []
      content {
        event_type   = "viewer-request"
        lambda_arn   = aws_lambda_function.auth[0].qualified_arn
        include_body = false
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Name        = "OpenGrid CloudFront"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# Get existing Route53 hosted zone
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# Route53 A record for subdomain
resource "aws_route53_record" "opengrid" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "opengrid.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.opengrid.domain_name
    zone_id                = aws_cloudfront_distribution.opengrid.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route53 AAAA record for IPv6 subdomain
resource "aws_route53_record" "opengrid_ipv6" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "opengrid.${var.domain_name}"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.opengrid.domain_name
    zone_id                = aws_cloudfront_distribution.opengrid.hosted_zone_id
    evaluate_target_health = false
  }
}
