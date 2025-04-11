output "ec2_key_arn" {
  value = aws_kms_key.ec2_key.arn
}

output "rds_key_arn" {
  value = aws_kms_key.rds_key.arn
}

output "s3_key_arn" {
  value = aws_kms_key.s3_key.arn
}

output "secretsmanager_key_arn" {
  value = aws_kms_key.secretsmanager_key.arn
}