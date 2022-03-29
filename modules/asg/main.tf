data "aws_ami" "amazon-ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_launch_template" "main" {
  name          = "${var.prefix}-lt"
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
    security_groups       = [aws_security_group.launch_template.id]
    subnet_id             = var.subnet_id
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
  name_prefix               = var.prefix
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "bestseller" {
  autoscaling_group_name = aws_autoscaling_group.bestseller.id
  lb_target_group_arn    = var.lb_target_group_arn
}

### AutoScaling Policies

# Scale out - CPU High
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.prefix}-scale-out"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = aws_autoscaling_group.bestseller.name
}

resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "${var.prefix}-scale-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bestseller.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_out.arn]
}

# Scale In
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.prefix}-scale-in"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = aws_autoscaling_group.bestseller.name
}

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "${var.prefix}-scale-in"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.bestseller.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_in.arn]
}