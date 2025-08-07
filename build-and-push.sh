#!/bin/bash

# Configuration
AWS_REGION=${AWS_REGION:-us-west-2}
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPOSITORY_NAME="legacy-health-backend"
IMAGE_TAG=${IMAGE_TAG:-latest}

# Full image URI
IMAGE_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}:${IMAGE_TAG}"

echo "Building and pushing Docker image for Lambda..."
echo "AWS Account: ${AWS_ACCOUNT_ID}"
echo "Region: ${AWS_REGION}"
echo "Repository: ${REPOSITORY_NAME}"
echo "Image URI: ${IMAGE_URI}"

# Create ECR repository if it doesn't exist
echo "Creating ECR repository if it doesn't exist..."
aws ecr create-repository \
    --repository-name ${REPOSITORY_NAME} \
    --region ${AWS_REGION} 2>/dev/null || true

# Get ECR login token
echo "Logging in to ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Build the Docker image
echo "Building Docker image..."
docker build -t ${REPOSITORY_NAME}:${IMAGE_TAG} .

# Tag the image for ECR
echo "Tagging image for ECR..."
docker tag ${REPOSITORY_NAME}:${IMAGE_TAG} ${IMAGE_URI}

# Push the image to ECR
echo "Pushing image to ECR..."
docker push ${IMAGE_URI}

echo "Successfully pushed image: ${IMAGE_URI}"
echo ""
echo "You can now update your Terraform with:"
echo "image_uri = \"${IMAGE_URI}\""