data "aws_ami" "amazon-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_launch_template" "main" {
  name = "${var.prefix}-lt"
  image_id      = data.aws_ami.amazon-ami.id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name

  user_data = fileexists("${local.module_path}/user-data.sh") ? filebase64("${local.module_path}/user-data.sh") : filebase64("${local.default_path}/user-data.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.ebs_volume_size
    }
  }

  network_interfaces {
      delete_on_termination = true
      security_groups = [ aws_security_group.launch_template.id ]
      subnet_id = var.subnet_id
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.common_tags,
      tomap({ "Name" = "${var.prefix}-lt" })
    )
  }
}

resource "aws_security_group" "launch_template" {
  name        = "Launch Template Configuration"
  description = "Allow Webservers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-lt" })
  )
}

resource "aws_autoscaling_group" "bestseller" {
  name_prefix = "${var.prefix}"
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  health_check_type = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id = aws_launch_template.main.id
    version = "$Latest"
  }
}