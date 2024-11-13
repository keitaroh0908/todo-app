terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "alb_log_replica" {
  bucket = "alb-log-replica-mc123004-sun-ac-jp"
}

resource "aws_s3_bucket_policy" "alb_log_replica" {
  bucket = aws_s3_bucket.alb_log_replica.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSSL"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.alb_log_replica.arn,
          "${aws_s3_bucket.alb_log_replica.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "alb_log_replica" {
  bucket = aws_s3_bucket.alb_log_replica.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "config_replica" {
  bucket = "config-replica-mc123004-sun-ac-jp"
}

resource "aws_s3_bucket_policy" "config_replica" {
  bucket = aws_s3_bucket.config_replica.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSSL"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.config_replica.arn,
          "${aws_s3_bucket.config_replica.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "config_replica" {
  bucket = aws_s3_bucket.config_replica.id
  versioning_configuration {
    status = "Enabled"
  }
}
