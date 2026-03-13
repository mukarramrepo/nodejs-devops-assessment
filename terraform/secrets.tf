resource "aws_secretsmanager_secret" "nodejs_secret" {
  name = "nodejs-app-secret-new"
}

resource "aws_secretsmanager_secret_version" "nodejs_secret_value" {
  secret_id     = aws_secretsmanager_secret.nodejs_secret.id
  secret_string = jsonencode({
    DB_PASSWORD = "mypassword123"
  })
}