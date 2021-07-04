output "private_ips" {
  value       = join(",", aws_instance.demo.*.private_ip)
}

output "public_ips" {
  value       = join(",", aws_instance.demo.*.public_ip)
}

output "instance_ids" {
  value       = join(",", aws_instance.demo.*.id)
}

output "instance_sg_id" {
  value       = aws_security_group.demo_instance.id
}

output "elb_sg_id" {
  value       = aws_security_group.demo_elb.id
}

output "role_arn" {
  value       = aws_iam_role.demo.arn
}

output "instance_profile_arn" {
  value       = aws_iam_role.demo.arn
}