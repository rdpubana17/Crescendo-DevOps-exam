provider "aws" {
  region = "us-east-1" # Replace with your AWS region
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 2}.0/24"
  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "InternetGateway"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "NatGateway"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_instance" "app" {
  count         = 2
  ami           = "ami-0f9de6e2d2f067fca" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[count.index].id
  tags = {
    Name = "AppInstance-${count.index}"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo apt install -y tomcat
  EOF
}

resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [] # Define security groups
  subnets            = aws_subnet.public[*].id
  tags = {
    Name = "ALB"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "ALBOrigin"
  }
  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "ALBOrigin"
    viewer_protocol_policy = "redirect-to-https"
  }

  tags = {
    Name = "CloudFront"
  }
}
