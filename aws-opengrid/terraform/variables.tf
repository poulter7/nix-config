variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
  default     = "jonathanpoulter.com"
}

variable "subdomain" {
  description = "Subdomain or path for the website"
  type        = string
  default     = "opengrid"
}

variable "bucket_name" {
  description = "S3 bucket name for website hosting"
  type        = string
  default     = "jonathanpoulter-opengrid"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the domain (must be in us-east-1)"
  type        = string
  # This should be provided or looked up
}

variable "enable_password_protection" {
  description = "Enable HTTP Basic Authentication for the website"
  type        = bool
  default     = true
}

variable "secrets_manager_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing authentication credentials (optional)"
  type        = string
  default     = ""
}

variable "auth_username" {
  description = "Username for HTTP Basic Authentication (ignored if using Secrets Manager)"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "auth_password" {
  description = "Password for HTTP Basic Authentication (ignored if using Secrets Manager)"
  type        = string
  default     = ""
  sensitive   = true
  
  validation {
    condition = (
      !var.enable_password_protection ||
      var.secrets_manager_secret_name != "" ||
      length(var.auth_password) >= 8
    )
    error_message = "When password protection is enabled, provide either a secrets_manager_secret_name or a password of at least 8 characters."
  }
}
