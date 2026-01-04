output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.opengrid.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.opengrid.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.opengrid.id
}

output "cloudfront_distribution_domain" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.opengrid.domain_name
}

output "website_url" {
  description = "URL of the website"
  value       = "https://${var.domain_name}/opengrid"
}

output "route53_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = data.aws_route53_zone.main.zone_id
}
