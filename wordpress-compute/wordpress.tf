data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

#resource "tls_private_key" "wordpress_key" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}
#
#resource "aws_key_pair" "wordpress_key" {
#  key_name   = "wordpress-key"
#  public_key = tls_private_key.wordpress_key.public_key_openssh
#}

resource "aws_launch_template" "wordpress_launch_template" {
  name = "wordpress-server-template"
  //key_name = "wordpress-key"
  iam_instance_profile {
    arn = aws_iam_instance_profile.ssm-iam-profile.arn
  }
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
    }
  }
  ebs_optimized                        = true
  image_id                             = data.aws_ami.ubuntu.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_market_options {
    market_type = "spot"
  }
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.wordpress_sg.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name   = "wordpress-server"
      Env    = "dev"
      Ownder = "Lev"
    }
  }
  user_data = base64encode(templatefile("${path.module}/user-data.sh", { db_host = data.terraform_remote_state.rds.outputs.rds.db_instance_endpoint, username = data.terraform_remote_state.rds.outputs.rds.db_instance_username, password = data.terraform_remote_state.rds.outputs.rds.db_instance_password }))
}

resource "aws_autoscaling_group" "wordpress_asg" {
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.vpc.private_subnets
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2

  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = aws_launch_template.wordpress_launch_template.latest_version
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}

resource "aws_lb" "wordpress" {
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.vpc.outputs.elb_sg.id]
  subnets            = data.terraform_remote_state.vpc.outputs.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
    Owner       = "Lev"
  }
}
resource "aws_lb_listener" "wordpress_lb_listener" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"
  //ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "asg_attachment_wordpress_tg" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  lb_target_group_arn    = aws_lb_target_group.wordpress_tg.arn
}

resource "aws_iam_instance_profile" "ssm-iam-profile" {
  name = "ec2_profile"
  role = aws_iam_role.ssm-iam-role.name
}

resource "aws_iam_role" "ssm-iam-role" {
  name               = "dev-ssm-role"
  description        = "The role for the developer resources EC2"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
  tags = {
    stack = "test"
  }
}
resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
  role       = aws_iam_role.ssm-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_route53_zone" "lev_labs" {
  name         = "lev-labs.com."
}

resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.lev_labs.zone_id
  name    = "wordpress.lev-labs.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.wordpress.dns_name]
}