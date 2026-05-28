terraform {
  required_version = "~> 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "web-application"
}

# Web server instances
resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-0c02fb55956c7d316" # ubuntu-22.04-server
  instance_type = "t3.medium"
  
  tags = {
    Name = "${var.project_name}-web-${count.index}"
  }
}

# Database
resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db"
  engine         = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  storage_type      = "gp2"
  
  db_name  = "webapp"
  username = "admin"
  password = "changeme123"
  
  skip_final_snapshot = true
}

# Another database
resource "aws_db_instance" "cache" {
  identifier     = "${var.project_name}-cache"
  engine         = "redis"
  engine_version = "7.0"
  instance_class = "cache.t3.micro"
}

# Lambda function
resource "aws_lambda_function" "api" {
  filename         = "api.zip"
  function_name    = "${var.project_name}-api"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.11"
  
  source_code_hash = filebase64sha256("api.zip")
}

# Another Lambda with different runtime
resource "aws_lambda_function" "processor" {
  filename         = "processor.zip"
  function_name    = "${var.project_name}-processor"
  role            = aws_iam_role.lambda_role.arn
  handler         = "app.handler"
  runtime         = "nodejs18.x"
  
  source_code_hash = filebase64sha256("processor.zip")
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  
  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = "nginx:1.18.3"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name  = "php-app"
      image = "php:8.3-fpm-alpine"
      portMappings = [
        {
          containerPort = 9000
        }
      ]
    },
    {
      name  = "database"
      image = "mariadb:10.11"
      environment = [
        {
          name  = "MYSQL_ROOT_PASSWORD"
          value = "secret"
        }
      ]
    }
  ])
}
