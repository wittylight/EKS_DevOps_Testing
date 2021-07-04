output "instance_sg_id" {
  value       = aws_security_group.demo_instance.id
}

output "elb_sg_id" {
  value       = aws_security_group.demo_elb.id
}

output "instance_role_arn" {
  value       = aws_iam_role.demo.arn
}

output "instance_profile_arn" {
  value       = aws_iam_role.demo.arn
}

output "launch_configuration_id" {
  value       = aws_launch_configuration.this.id
}

output "launch_configuration_name" {
  value       = aws_launch_configuration.this.name
}

output "autoscaling_group_id" {
  value       = aws_autoscaling_group.this.id
}

output "autoscaling_group_name" {
  value       = aws_autoscaling_group.this.name
}

output "autoscaling_group_arn" {
  value       = aws_autoscaling_group.this.arn
}

output "elb_arn" {
  value       = aws_elb.elb.arn
}