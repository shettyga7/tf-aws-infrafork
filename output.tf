output "rds_endpoint" {
  value       = aws_db_instance.webapp_rds.endpoint
  description = "RDS Endpoint"
}