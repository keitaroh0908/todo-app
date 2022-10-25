module "logs" {
  source = "../../elements/s3/bucket"

  bucket_name = "logs.graduation-thesis.bs219031.sun.ac.jp"
  bucket_acl  = "private"
}

resource "aws_s3_bucket" "web" {
  bucket = "www.graduation-thesis.bs219031.sun.ac.jp"
  acl    = "private"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.web.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Principal = {
          AWS = var.cloudfront_origin_access_identity_iam_arn
        }
        Resource = "${aws_s3_bucket.web.arn}/*"
      }
    ]
  })
}
