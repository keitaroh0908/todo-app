output "dns_name" {
  value = aws_alb.this.dns_name
}

output "target_group_arn" {
  value = aws_alb_target_group.this.arn
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "zone_id" {
  value = aws_alb.this.zone_id
}
