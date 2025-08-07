variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the application, used for resource naming"
  type        = string
  default     = "legacy-builder"
}

# Pls do not attempt to interpolate this with the app name or something,
# because actually managing the ECR repo belongs in a seperate stack
variable "ecr_repository_name" {
  description = "ECR repository name for the Lambda container image"
  type        = string
  default     = "legacy/legacy-builder"
}

variable "ecr_image_tag_target" {
  description = "Tag name to use from the ECR repository"
  type        = string
  default     = "latest"
}