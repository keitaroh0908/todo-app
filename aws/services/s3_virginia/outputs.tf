output "alb_log_replica_bucket_arn" {
  value = aws_s3_bucket.alb_log_replica.arn
}

output "config_replica_bucket_arn" {
  value = aws_s3_bucket.config_replica.arn
}
