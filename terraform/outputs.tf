# outputs.tf

# Output EC2 instance ID
output "ec2_instance_id" {
  description = "The ID of the EC2 instance running the Node.js app"
  value       = aws_instance.node_app.id
}

# Output EC2 public IP
output "ec2_public_ip" {
  description = "Public IP of the Node.js EC2 instance"
  value       = aws_instance.node_app.public_ip
}

# Output EC2 private IP
output "ec2_private_ip" {
  description = "Private IP of the Node.js EC2 instance"
  value       = aws_instance.node_app.private_ip
}

# Output App Secret ARN
output "app_secret_arn" {
  description = "ARN of the secret stored in AWS Secrets Manager"
  value       = aws_secretsmanager_secret.app_secret.arn
}

# Output IAM Role ARN
output "ec2_iam_role_arn" {
  description = "ARN of the IAM Role attached to the EC2 instance"
  value       = aws_iam_role.ec2_role.arn
}