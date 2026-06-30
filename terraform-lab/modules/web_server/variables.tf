variable "ami_id" {
  description = "The AMI ID to use for the server"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "server_name" {
  description = "Value for the Name tag"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile name to associate with the instance"
  type        = string
  default     = null
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "web-server-sg"
}
