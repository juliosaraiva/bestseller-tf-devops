output "launch_template_id" {
  value = aws_launch_template.main.id
}

output "launch_template_arn" {
  value = aws_launch_template.main.arn
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.bestseller.id
}