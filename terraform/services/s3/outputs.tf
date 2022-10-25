
output "web_bucket_id" {
  value = aws_s3_bucket.web.id
}

output "web_bucket_regional_domain_name" {
  value = aws_s3_bucket.web.bucket_regional_domain_name
}
