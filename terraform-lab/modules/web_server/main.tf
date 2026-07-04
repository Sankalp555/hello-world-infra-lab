resource "aws_security_group" "this" {
  name        = var.sg_name
  description = "Security group for web server"
  vpc_id      = var.vpc_id

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

resource "aws_launch_template" "this" {
  name_prefix   = "${var.server_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.this.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>High Availability Rails Server</h1>" > /var/www/html/index.html
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.server_name}-asg"
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [var.target_group_arn]
  health_check_type   = "ELB"

  min_size         = 1
  max_size         = 3
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.server_name
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}
