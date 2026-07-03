variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "terraform-lab-sg"
}

variable "key_name" {
  description = "Name of the AWS Key Pair"
  type        = string
  default     = "aws-key"
}

variable "domain_name" {
  description = "The domain name for the application"
  type        = string
  default     = "workorn.com"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  default     = "postgres"
}
