output "public_subnets" {
  value = local.public_subnets
}

output "private_subnets" {
  value = local.private_subnets
}

output "rds_sg" {
  value = aws_security_group.rds_sg
}
output "elb_sg" {
  value = aws_security_group.elb_sg
}

output "wordpress_sg" {
  value = aws_security_group.wordpress_sg
}

output "vpc" {
  value = module.vpc
}