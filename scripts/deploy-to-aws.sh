#!/bin/bash
set -e

echo "🚀 Deploying Apache Server to AWS..."

# Get ECR repository URL from Terraform output
ECR_URL=$(cd infrastructure/terraform && terraform output -raw ecr_repository_url)
AWS_REGION=$(cd infrastructure/terraform && terraform output -raw aws_region 2>/dev/null || echo "us-east-1")

echo "📦 ECR Repository: $ECR_URL"

# Login to ECR
echo "🔐 Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

# Build and push image for AMD64 platform (AWS Fargate requirement)
echo "🔨 Building Docker image for AMD64 platform..."

# Set up buildx if not already done
docker buildx create --use --name multi-arch-builder 2>/dev/null || true

# Build for AMD64 and push directly to ECR
docker buildx build --platform linux/amd64 -t $ECR_URL:latest --push .

# Update ECS service to use new image
echo "🔄 Updating ECS service..."
CLUSTER_NAME="modern-apache-server-cluster"
SERVICE_NAME="modern-apache-server-service"

aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --force-new-deployment \
    --region $AWS_REGION

echo "⏳ Waiting for deployment to complete..."
aws ecs wait services-stable \
    --cluster $CLUSTER_NAME \
    --services $SERVICE_NAME \
    --region $AWS_REGION

# Get load balancer URL
LB_URL=$(cd infrastructure/terraform && terraform output -raw load_balancer_url)

echo "✅ Deployment complete!"
echo "🌐 Your Apache server is available at: $LB_URL"
echo "⏱️  Note: It may take a few minutes for the load balancer to route traffic"