output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_a_subnet_id" {
  value = aws_subnet.private_a.id
}

output "public_a_subnet_id" {
  value = aws_subnet.public_a.id
}