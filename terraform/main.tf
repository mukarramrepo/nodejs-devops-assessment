provider "aws" {
  region = var.region
}

resource "aws_instance" "node_app" {
  ami           = "ami-0f559c3642608c138"
  instance_type = var.instance_type

  tags = {
    Name        = "nodejs-app"
    Environment = var.environment
  }
}

# AWS Secrets Manager secret for Node.js app
resource "aws_secretsmanager_secret" "app_secret" {
  name = "nodejs-app-secret-new"
}

resource "aws_secretsmanager_secret_version" "app_secret_version" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = "my-super-secret"
}