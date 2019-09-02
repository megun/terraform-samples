#!/bin/bash

yum update -y
yum install mariadb -y
yum install nc -y
amazon-linux-extras install nginx1 -y
systemctl start nginx
