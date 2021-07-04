provider "aws" {
  region = var.region

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

#############################
# Base AMI created by Packer
#############################
data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "tag:Purpose"
    values = ["BaseAMI"]
  }

  owners = ["self"]
}


resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "something"

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

#######################
# User_Data
#######################
locals {
  user_data = <<EOF
#!/bin/bash
apt install stress -y
aws s3 cp s3://bcaa-demo-s3bucket/index.html /tmp/index.html
mkdir -p /home/ubuntu/nginx-html
mv /tmp/index.html /home/ubuntu/nginx-html
docker run -d -v /home/ubuntu/nginx-html:/usr/share/nginx/html --name mynginx -p 80:80 nginx
EOF
}


#######################
# Launch configuration
#######################
resource "aws_launch_configuration" "this" {
  name_prefix                 = "lc-demo5-"
  image_id                    = data.aws_ami.ami.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.demo.name
  key_name                    = "auto"
  security_groups             = [aws_security_group.demo_instance.id]
  associate_public_ip_address = true
  enable_monitoring           = true
  user_data_base64            = base64encode(local.user_data)

  ebs_block_device {
    device_name = "/dev/xvdz"
    volume_size = "50"
    volume_type = "gp2"
    delete_on_termination = true
  }

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


####################
# Autoscaling group
####################
resource "aws_autoscaling_group" "this" {
  #name = "demo4-autoscaling-group"
  name = "${aws_launch_configuration.this.name}-asg"
  launch_configuration      = aws_launch_configuration.this.name
  vpc_zone_identifier       = var.subnet_ids
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  load_balancers            = [aws_elb.elb.id]
  force_delete              = var.force_delete
  wait_for_capacity_timeout = 0
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn
  termination_policies      = ["OldestInstance"]
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = var.metrics_granularity

#  health_check_type         = "EC2"
  health_check_type         = "ELB"
  health_check_grace_period = 120


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "demo5-scale-in"
  scaling_adjustment     = var.scale_in_scaling_adjustment
  adjustment_type        = var.scale_in_adjustment_type
  policy_type            = var.scale_in_policy_type
  cooldown               = var.scale_in_cooldown_seconds
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "demo5-scale-out"
  scaling_adjustment     = var.scale_out_scaling_adjustment
  adjustment_type        = var.scale_out_adjustment_type
  policy_type            = var.scale_out_policy_type
  cooldown               = var.scale_out_cooldown_seconds
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "demo5-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_utilization_high_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_utilization_high_period_seconds
  statistic           = var.cpu_utilization_high_statistic
  threshold           = var.cpu_utilization_high_threshold_percent

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "Scale up if CPU utilization is above ${var.cpu_utilization_high_threshold_percent} for ${var.cpu_utilization_high_period_seconds} seconds"
  alarm_actions     = [aws_autoscaling_policy.scale_in.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "demo5-cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_utilization_low_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_utilization_low_period_seconds
  statistic           = var.cpu_utilization_low_statistic
  threshold           = var.cpu_utilization_low_threshold_percent

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "Scale down if the CPU utilization is below ${var.cpu_utilization_low_threshold_percent} for ${var.cpu_utilization_low_period_seconds} seconds"
  alarm_actions     = [aws_autoscaling_policy.scale_out.arn]
}

