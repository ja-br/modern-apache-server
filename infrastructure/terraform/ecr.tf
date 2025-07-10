# ECR Repository - where we'll store our Docker image
resource "aws_ecr_repository" "apache_server" {
  name                 = var.project_name
  image_tag_mutability = "MUTABLE"

  # Scan images for vulnerabilities
  image_scanning_configuration {
    scan_on_push = true
  }

  # Encrypt images at rest
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}

# Lifecycle policy to manage image cleanup
resource "aws_ecr_lifecycle_policy" "apache_server" {
  repository = aws_ecr_repository.apache_server.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 production images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "prod", "release"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 3 latest images" 
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["latest"]
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Delete untagged images older than 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}