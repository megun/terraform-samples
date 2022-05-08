#!/bin/bash

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)

# install packages
yum update -y
amazon-linux-extras install php8.0 nginx1

# install code-deploy-agent
aws ssm send-command \
    --document-name "AWS-ConfigureAWSPackage" \
    --instance-id $${instance_id} \
    --parameters action=Install,name=AWSCodeDeployAgent \
    --region ap-northeast-1

# settting systemd file
cat <<EOF > /etc/systemd/system/php-fpm.service.d/10_service.conf
[Service]
EnvironmentFile=/root/.env
EOF

# create env file
touch /root/.env

# edit php-fpm config
sed -i s'/^;clear_env = no/clear_env = no/' /etc/php-fpm.d/www.conf

# reflecting systemd settings
systemctl daemon-reload
