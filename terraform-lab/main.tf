terraform {
  backend "s3" {
    bucket         = "terraform-state-lab-sankalp-555"
    key            = "hello-world/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources for Network
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Data source for AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Data source for Account ID
data "aws_caller_identity" "current" {}

# 1. IAM Module
module "iam" {
  source      = "./modules/iam"
  name_prefix = "rails-lab"
  account_id  = data.aws_caller_identity.current.account_id
}

# 2. DNS and SSL Module (Foundation for Security)
module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name
}

# 3. ALB Module (Front Door)
module "alb" {
  source          = "./modules/alb"
  name_prefix     = "rails-lab"
  vpc_id          = data.aws_vpc.default.id
  public_subnets  = data.aws_subnets.default.ids
  certificate_arn = module.dns.certificate_arn
}

# 4. Web Server Module (Compute - High Availability)
module "my_web_server" {
  source = "./modules/web_server"

  ami_id                = data.aws_ami.ubuntu.id
  instance_type         = var.instance_type
  server_name           = "Rails-Prod-Lab-V2"
  key_name              = var.key_name
  sg_name               = var.sg_name
  iam_instance_profile  = module.iam.instance_profile_name
  alb_security_group_id = module.alb.alb_security_group_id
  vpc_id                = data.aws_vpc.default.id
  subnet_ids            = data.aws_subnets.default.ids
  target_group_arn      = module.alb.target_group_arn
}

# 5. Route 53 Records (Identity pointing to Front Door)
resource "aws_route53_record" "root" {
  zone_id = module.dns.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = module.dns.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }
}

# 6. RDS Module
module "rds" {
  source = "./modules/rds"

  name_prefix      = "rails-lab"
  vpc_id           = data.aws_vpc.default.id
  subnet_ids       = data.aws_subnets.default.ids
  web_server_sg_id = module.my_web_server.security_group_id
  db_password      = var.db_password
}

# 7. Secrets Module
module "secrets" {
  source = "./modules/secrets"

  name_prefix     = "rails-lab"
  db_password     = var.db_password
  secret_key_base = var.secret_key_base
  rds_endpoint    = split(":", module.rds.rds_endpoint)[0]
}
