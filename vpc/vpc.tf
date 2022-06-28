module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  name    = "wordpress"
  cidr    = var.vpc_cidr

  azs             = var.azs
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true
  private_subnet_tags = merge(
    var.tags,
    {
      Name = "${var.name}-private"
    },
  )
  public_subnet_tags = merge(
    var.tags,
    {
      Name = "${var.name}-public"
    },
  )
  tags = merge(
    var.tags,
    {
      Name = var.name
    },
  )
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "allow incomming traffic for RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "mysql from wordpress"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = merge(
    var.tags,
    {
      Name = "allow-wordpress-to-rds"
    },
  )
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "allow incomming traffic from ELB"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "HTTP from ELB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = merge(
    var.tags,
    {
      Name = "allow-http-from-elb"
    },
  )
}

resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "allow incomming traffic from the internet and to wordpress servers"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description      = "HTTPs from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.tags,
    {
      Name = "allow-http-from-internet-to-elb"
    },
  )
}

resource "aws_security_group_rule" "outgoing_traffic_for_elb" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.elb_sg.id
  to_port           = 0
  type = "egress"
  source_security_group_id = aws_security_group.wordpress_sg.id
}

locals {
  #for convention public subnets are x.x.[10,11,12].x and private are x.x.[100,101,102].x
  public_subnets = [ for network in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, (10+network))]
  private_subnets = [ for network in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, (100+network))]
}