resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group for web server"

  # HTTP from ALB or anywhere
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = var.alb_security_group_id == "" ? ["0.0.0.0/0"] : null
    security_groups = var.alb_security_group_id == "" ? null : [var.alb_security_group_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 3000 from ALB or anywhere
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = var.alb_security_group_id == "" ? ["0.0.0.0/0"] : null
    security_groups = var.alb_security_group_id == "" ? null : [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.server_name
  }
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data_replace_on_change = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Modularized Rails Server</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = var.server_name
  }
}
