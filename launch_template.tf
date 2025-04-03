resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "csye6225-launch-template"
  image_id      = var.custom_ami
  instance_type = "t2.micro"


  user_data = base64encode(<<-EOF
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

    cd /opt/webapp
    sudo npm install
    sudo systemctl restart webapp
  EOF
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WebApp-ASG"
    }
  }
}