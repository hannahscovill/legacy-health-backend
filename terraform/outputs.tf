# output "api_gateway_url" {
#   description = "URL of the API Gateway"
#   value       = aws_api_gateway_deployment.api.invoke_url
# }

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.api.arn
}

# output "dynamodb_table_name" {
#   description = "Name of the DynamoDB patients table"
#   value       = aws_dynamodb_table.legacy_builder.name
# }

output "api_gateway_rest_api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.api.id
}

output "ecr_repository_name" {
  description = "Name of the ECR repository used for the Lambda container"
  value       = var.ecr_repository_name
}