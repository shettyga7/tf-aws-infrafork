# Create Security Group for Web Application
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow inbound traffic for application and SSH"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Create EC2 Instance
resource "aws_instance" "web_instance" {
  ami                         = var.custom_ami
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.public_subnets[*].id, 0)
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  disable_api_termination     = false

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y mysql-client unzip

    echo 'DB_HOST="${aws_db_instance.webapp_rds.endpoint}"' | sudo tee -a /etc/environment
    echo 'DB_USER="csye6225"' | sudo tee -a /etc/environment
    echo 'DB_PASS="${var.db_password}"' | sudo tee -a /etc/environment
    echo 'DB_NAME="csye6225"' | sudo tee -a /etc/environment
    echo 'AWS_REGION="us-east-1"' | sudo tee -a /etc/environment
    echo 'S3_BUCKET_NAME="csye6225-webapp-bucket"' | sudo tee -a /etc/environment
    source /etc/environment

    sudo cp /opt/webapp/webapp/webapp.service /etc/systemd/system/webapp.service
    sudo systemctl daemon-reload
    sudo systemctl enable webapp
    sudo systemctl start webapp
  EOF

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "WebApp-EC2"
  }
}