terraform {
  backend "s3" {
    bucket = "terraform-state-calamari"
    region = "us-west-2"
    key    = "legacy-backend"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = "Legacy Health Backend"
      ManagedBy = "Terraform"
    }
  }
}


# Hmm, claude, can you share your thought process here please
# # Build the Lambda function
# resource "null_resource" "build_lambda" {
#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = "cd ${path.module}/.. && npm install && npm run build"
#   }
# }

# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for Lambda function
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.app_name}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      # {
      #   Effect = "Allow"
      #   Action = [
      #     "dynamodb:GetItem",
      #     "dynamodb:PutItem",
      #     "dynamodb:UpdateItem",
      #     "dynamodb:DeleteItem",
      #     "dynamodb:Query",
      #     "dynamodb:Scan"
      #   ]
      #   Resource = [
      #     "${aws_dynamodb_table.legacy_builder.arn}",
      #     "${aws_dynamodb_table.legacy_builder.arn}/index/*"
      #   ]
      # }
    ]
  })
}

# # CloudWatch Log Group for Lambda
# resource "aws_cloudwatch_log_group" "lambda_logs" {
#   name              = "/aws/lambda/${aws_lambda_function.api.function_name}"
#   retention_in_days = 14
#   tags              = local.common_tags
# }

data "aws_ecr_image" "lambda_image" {
  repository_name = var.ecr_repository_name
  image_tag       = "latest"
}

# Lambda function
resource "aws_lambda_function" "api" {
  function_name = var.app_name
  role          = aws_iam_role.lambda_role.arn
  timeout       = 30
  memory_size   = 256
  package_type  = "Image"

  image_uri = data.aws_ecr_image.lambda_image

  # environment {
  #   variables = {
  #     TABLE   = aws_dynamodb_table.legacy_builder.name
  #   }
  # }

  depends_on = [
    aws_iam_role_policy.lambda_policy
  ]

}

# # DynamoDB table for patients
# resource "aws_dynamodb_table" "legacy_builder" {
#   name         = var.app_name
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"

#   attribute {
#     name = "id"
#     type = "S"
#   }

#   attribute {
#     name = "email"
#     type = "S"
#   }

# }

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "${var.app_name}-api"
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
