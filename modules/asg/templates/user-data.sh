#!/bin/bash

amazon-linux-extras enable nginx1

yum clean metadata ; yum makecache ; yum update -y

yum install nginx -y

systemctl enable nginx.service
systemctl start nginx.service
