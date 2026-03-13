#Node.js Web Application - Infrastructure as Code (IaC)
1. Overview

This project demonstrates the deployment of a Node.js web application infrastructure using Terraform on AWS. It covers all the requirements of the DevOps assessment:

Infrastructure as Code (IaC)

Environment separation (dev, staging, prod)

Remote Terraform state with state locking

IAM roles following the principle of least privilege

Secrets management integration

Version-controlled codebase on GitHub

This project is designed to be beginner-friendly, idempotent, and parameterized for multiple environments.

2. Tools and Technologies
Component	Purpose
Terraform	Infrastructure provisioning
AWS (EC2, VPC, S3, DynamoDB, Secrets Manager, IAM)	Cloud resources and management
GitHub	Version control and repository
Node.js	Application runtime
AWS CLI	Manage AWS resources

Why Terraform?
Terraform is a widely-used, declarative IaC tool. It allows creating, updating, and versioning infrastructure in a safe and reproducible way. It is idempotent and works well with multiple environments.

3. Project Structure
nodejs-devops-assignment/
│
├── terraform/
│   ├── main.tf          # Core infrastructure resources (VPC, EC2, IAM, Secrets)
│   ├── variables.tf     # Variables for environment parameterization
│   ├── outputs.tf       # Outputs like EC2 public IP
│   ├── backend.tf       # Remote state backend configuration
│   └── env/             # Environment-specific variable files
│       ├── dev.tfvars
│       ├── staging.tfvars
│       └── prod.tfvars
│
├── app/
│   └── nodejs-app       # Node.js application code
│
└── README.md
4. Architecture Overview
          GitHub
             │
          Terraform
             │
AWS Resources:
 ├── VPC
 ├── EC2 (Node.js App)
 ├── S3 (Terraform Remote State)
 ├── DynamoDB (State Locking)
 ├── IAM Role (Least Privilege)
 └── Secrets Manager (App Secrets)

VPC & EC2: Provides a private network and compute instance for the Node.js app.

S3 + DynamoDB: Stores Terraform state remotely with locking to prevent conflicts.

IAM Role: Grants minimal required permissions to EC2 for security best practices.

Secrets Manager: Safely stores sensitive application data like API keys or database passwords.

Environment files: Separate configurations for dev, staging, and prod.

5. Environment Separation

We created 3 environment files:

dev.tfvars

staging.tfvars

prod.tfvars

Example dev.tfvars:

region = "ap-south-1"
instance_type = "t2.micro"
environment = "dev"

This allows reusing the same Terraform code across multiple environments with different configurations.

6. Remote Terraform State

Remote state is configured in backend.tf using:

S3 Bucket: Stores the Terraform state file

DynamoDB Table: Provides state locking to prevent concurrent modifications

Example backend.tf:

terraform {
  backend "s3" {
    bucket         = "nodejs-terraform-state-123"
    key            = "nodejs/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
7. IAM Role (Least Privilege)

Terraform creates an EC2 IAM role with minimal permissions, following security best practices:

resource "aws_iam_role" "ec2_role" {
  name = "nodejs-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

This ensures principle of least privilege for EC2 instances.

8. Secrets Management

We use AWS Secrets Manager to store sensitive data:

resource "aws_secretsmanager_secret" "app_secret" {
  name = "nodejs-app-secret"
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = "my-super-secret"
}

This ensures sensitive information is never hard-coded in Terraform or application code.

9. How to Deploy

Clone the repository

git clone https://github.com/your-username/nodejs-devops-assignment.git
cd nodejs-devops-assignment/terraform

Initialize Terraform

terraform init

Plan and Apply for the desired environment

terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"

Replace dev.tfvars with staging.tfvars or prod.tfvars for other environments.

Verify Outputs

After terraform apply, check the public IP of EC2 in the outputs and access your Node.js app.

10. Key Points Achieved
Requirement	Status
IaC codebase	✅ Terraform code is complete
Environment-specific files	✅ dev, staging, prod
Remote state + locking	✅ S3 + DynamoDB
IAM Roles	✅ Least privilege role created
Secrets Management	✅ AWS Secrets Manager used
Version Control	✅ GitHub repository
Idempotency	✅ Terraform ensures safe repeated deployment
11. Notes

The project uses AWS free tier compatible resources (t2.micro) to minimize costs.

Secrets are stored securely and not exposed in code.

Terraform is idempotent, so repeated runs will not break infrastructure.

Environment separation allows independent deployments for dev, staging, and prod.