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

variable "auth_username" {
  description = "Username for HTTP Basic Authentication"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "auth_password" {
  description = "Password for HTTP Basic Authentication"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.auth_password) >= 8
    error_message = "Password must be at least 8 characters long for security."
  }
}
