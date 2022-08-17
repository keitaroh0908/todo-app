module "images" {
  source = "../../elements/s3/bucket"

  bucket_name = "images.graduation-thesis.bs219031.sun.ac.jp"
  bucket_acl  = "private"
}

resource "aws_s3_bucket_policy" "images" {
  bucket = module.images.bucket_name
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.origin_access_identity_id}"
        }
        Resource = "arn:aws:s3:::${module.images.bucket_name}/*"
      }
    ]
  })
}

module "logs" {
  source = "../../elements/s3/bucket"

  bucket_name = "logs.graduation-thesis.bs219031.sun.ac.jp"
  bucket_acl  = "private"
}
