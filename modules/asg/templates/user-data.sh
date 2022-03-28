#!/bin/bash

yum makecache ; yum update -y

yum install nginx -y

systemctl enable nginx.service
systemctl start nginx.service

