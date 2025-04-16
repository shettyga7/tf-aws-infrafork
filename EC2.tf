# ✅ Application Security Group (used in EC2)
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow access to app from Load Balancer SG"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
    # SSH access only from Load Balancer SG
    # cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # App access only from Load Balancer SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-security-group"
  }
}

# Create EC2 Instance
# resource "aws_instance" "web_instance" {
#   ami                         = var.custom_ami
#   instance_type               = "t2.micro"
#   subnet_id                   = element(aws_subnet.public_subnets[*].id, 0)
#   vpc_security_group_ids      = [aws_security_group.app_sg.id]
#   iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
#   associate_public_ip_address = true
#   disable_api_termination     = false

#   user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install -y mysql-client unzip

#     echo 'DB_HOST="${aws_db_instance.webapp_rds.endpoint}"' | sudo tee -a /etc/environment
#     echo 'DB_USER="csye6225"' | sudo tee -a /etc/environment
#     echo 'DB_PASS="${var.db_password}"' | sudo tee -a /etc/environment
#     echo 'DB_NAME="csye6225"' | sudo tee -a /etc/environment
#     echo 'AWS_REGION="us-east-1"' | sudo tee -a /etc/environment
#     echo 'S3_BUCKET_NAME="csye6225-webapp-bucket"' | sudo tee -a /etc/environment
#     source /etc/environment

#     sudo systemctl restart webapp
#   EOF

#   root_block_device {
#     volume_size           = 25
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "WebApp-EC2"
#   }
# }