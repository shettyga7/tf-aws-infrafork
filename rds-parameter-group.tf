resource "aws_db_parameter_group" "db_parameters" {
  name   = "rds-parameter-group"
  family = "mysql8.0" # Make sure this matches your MySQL version

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  tags = {
    Name = "Custom Parameter Group"
  }
}