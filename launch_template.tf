resource "aws_launch_template" "web_launch_template" {
  name          = "csye6225-launch-template"
  image_id      = var.custom_ami
  instance_type = "t2.micro"


  user_data = base64encode(<<-EOF
    #!/bin/bash

    sudo apt update -y
    # sudo apt install -y mysql-client unzip curl -y

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    export PATH=$PATH:/usr/local/bin

    # Fetch DB password securely from Secrets Manager
    SECRET_NAME="db-password-v27"
    REGION="us-east-1"
    # Retrieve DB password from AWS Secrets Manager
    DB_PASS=$(aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --region "$REGION" --query SecretString --output text)

    echo "DB_HOST=${aws_db_instance.webapp_rds.endpoint}" | sudo tee -a /etc/environment
    echo 'DB_USER="csye6225"' | sudo tee -a /etc/environment
    echo "DB_PASS=$DB_PASS" | sudo tee -a /etc/environment
    echo 'DB_NAME="csye6225"' | sudo tee -a /etc/environment
    echo "AWS_REGION=$REGION" | sudo tee -a /etc/environment
    echo 'S3_BUCKET_NAME="csye6225-webapp-bucket"' | sudo tee -a /etc/environment
    source /etc/environment

    cd /opt/webapp
    sudo npm install
    sudo systemctl restart webapp
  EOF
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 25
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = module.kms.ec2_key_arn
    }
  }

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