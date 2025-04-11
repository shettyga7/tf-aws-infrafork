output "rds_endpoint" {
  value       = aws_db_instance.webapp_rds.endpoint
  description = "RDS Endpoint"
}

output "rds_key_arn" {
  value       = module.kms.rds_key_arn
  description = "KMS key ARN used for RDS encryption"
}

output "ec2_key_arn" {
  value       = module.kms.ec2_key_arn
  description = "KMS key ARN used for EC2 volume encryption"
}

output "s3_key_arn" {
  value       = module.kms.s3_key_arn
  description = "KMS key ARN used for S3 encryption"
}

output "secretsmanager_key_arn" {
  value       = module.kms.secretsmanager_key_arn
  description = "KMS key ARN used for Secrets Manager"
}