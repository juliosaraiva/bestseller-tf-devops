output "load_balancer_id" {
  value = aws_lb.nginx.id
}

output "target_group_arn" {
  value = aws_lb_target_group.nginx.arn
}

output "load_balancer_endpoint" {
  value = aws_lb.nginx.dns_name
}