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

# 1. IAM Module - Creates the "Identity" for the server
module "iam" {
  source      = "./modules/iam"
  name_prefix = "rails-lab"
}

# 2. Web Server Module - Creates the "Hardware" and "Security"
module "my_web_server" {
  source = "./modules/web_server"

  ami_id               = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  server_name          = "Rails-Prod-Lab"
  key_name             = var.key_name
  sg_name              = var.sg_name
  iam_instance_profile = module.iam.instance_profile_name
}

# 3. Elastic IP - Gives the server a permanent "Phone Number"
resource "aws_eip" "app_eip" {
  instance = module.my_web_server.instance_id
  domain   = "vpc"

  tags = {
    Name = "Rails-Prod-EIP"
  }
}
