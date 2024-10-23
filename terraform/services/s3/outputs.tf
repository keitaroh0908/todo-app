output "alb_log_bucket_name" {
  value = aws_s3_bucket.alb_log.bucket
}

output "config_bucket_name" {
  value = aws_s3_bucket.config.bucket
}
