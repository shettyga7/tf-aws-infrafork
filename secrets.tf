resource "aws_secretsmanager_secret" "db_password" {
  name        = "db-password-v21"
  description = "Database password stored securely"
  kms_key_id  = module.kms.secretsmanager_key_arn
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}