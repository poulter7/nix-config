# Fetch credentials from AWS Secrets Manager if secret name is provided
data "aws_secretsmanager_secret_version" "auth_credentials" {
  count     = var.enable_password_protection && var.secrets_manager_secret_name != "" ? 1 : 0
  secret_id = var.secrets_manager_secret_name
}

locals {
  # Parse credentials from Secrets Manager or use variables
  auth_credentials = var.secrets_manager_secret_name != "" && var.enable_password_protection ? jsondecode(data.aws_secretsmanager_secret_version.auth_credentials[0].secret_string) : null
  
  final_auth_username = var.secrets_manager_secret_name != "" && var.enable_password_protection ? local.auth_credentials.username : var.auth_username
  final_auth_password = var.secrets_manager_secret_name != "" && var.enable_password_protection ? local.auth_credentials.password : var.auth_password
}

# Lambda@Edge function for Basic Authentication
# Credentials are fetched from AWS Secrets Manager during terraform apply if configured,
# or from terraform variables. Lambda@Edge cannot access Secrets Manager at runtime.
resource "aws_lambda_function" "auth" {
  count            = var.enable_password_protection ? 1 : 0
  provider         = aws.us_east_1  # Lambda@Edge must be in us-east-1
  filename         = "${path.module}/lambda/auth.zip"
  function_name    = "opengrid-basic-auth"
  role            = aws_iam_role.lambda_edge[0].arn
  handler         = "index.handler"
  source_code_hash = data.archive_file.auth_lambda[0].output_base64sha256
  runtime         = "nodejs20.x"
  publish         = true

  environment {
    variables = {
      AUTH_USER = local.final_auth_username
      AUTH_PASS = local.final_auth_password
    }
  }

  tags = {
    Name        = "OpenGrid Auth Lambda"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# IAM role for Lambda@Edge
resource "aws_iam_role" "lambda_edge" {
  count = var.enable_password_protection ? 1 : 0
  name = "opengrid-lambda-edge-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = {
    Name        = "OpenGrid Lambda Edge Role"
    ManagedBy   = "Terraform"
  }
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_edge_policy" {
  count      = var.enable_password_protection ? 1 : 0
  role       = aws_iam_role.lambda_edge[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM policy for reading from Secrets Manager (only needed during terraform apply)
resource "aws_iam_role_policy" "secrets_manager_read" {
  count = var.enable_password_protection && var.secrets_manager_secret_name != "" ? 1 : 0
  name  = "SecretsManagerRead"
  role  = aws_iam_role.lambda_edge[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = data.aws_secretsmanager_secret_version.auth_credentials[0].arn
      }
    ]
  })
}

# Create the Lambda deployment package
data "archive_file" "auth_lambda" {
  count       = var.enable_password_protection ? 1 : 0
  type        = "zip"
  source_file = "${path.module}/lambda/index.js"
  output_path = "${path.module}/lambda/auth.zip"
}
