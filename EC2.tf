# Create Security Group for Web Application
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow inbound traffic for application and SSH"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Application Port
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
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
resource "aws_instance" "web_instance" {
  ami                         = var.custom_ami # Custom AMI created from Packer
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  disable_api_termination     = false # Allow instance termination

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true # Terminate EBS with instance
  }

  tags = {
    Name = "web-instance"
  }
}
