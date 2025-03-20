#!/bin/bash

sudo apt update -y
sudo apt install -y mysql-client unzip

echo "DB_HOST=${aws_db_instance.webapp_rds.endpoint}" >> /etc/environment
echo "DB_USER=csye6225" >> /etc/environment
echo "DB_PASS=${var.db_password}" >> /etc/environment
echo "DB_NAME=csye6225" >> /etc/environment
source /etc/environment

sudo cp /opt/webapp/webapp/webapp.service /etc/systemd/system/webapp.service
sudo systemctl daemon-reload
sudo systemctl enable webapp
sudo systemctl start webapp
