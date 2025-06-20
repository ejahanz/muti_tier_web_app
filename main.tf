# Root main.tf file for AWS Multi-Tier Web Application using Terraform

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = var.project_name
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    Project = var.project_name
  }
}

module "web_server_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "${var.project_name}-web"
  min_size = 2
  max_size = 4
  desired_capacity = 2

  vpc_zone_identifier = module.vpc.public_subnets

  launch_template = {
    name_prefix   = "${var.project_name}-lt"
    image_id      = data.aws_ami.amazon_linux.id
    instance_type = var.web_instance_type
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.project_name}-web"
      propagate_at_launch = true
    }
  ]
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_db_instance" "webapp_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_type
  name                 = "webapp"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow DB traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

output "vpc_id" {
  value = module.vpc.vpc_id
}
