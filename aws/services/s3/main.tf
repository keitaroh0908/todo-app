terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-mc123004-sun-ac-jp"
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSSL"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.alb_log.arn,
          "${aws_s3_bucket.alb_log.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::582318560864:root"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_log.arn}/AWSLogs/${var.aws_account_id}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id     = "MoveToGlacierAndDelete"
    status = "Enabled"

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 365
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "alb_log" {
  role   = aws_iam_role.alb_log.arn
  bucket = aws_s3_bucket.alb_log.id

  rule {
    status   = "Enabled"
    priority = 1

    destination {
      bucket        = var.alb_log_replica_bucket_arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Disabled"
    }

    filter {
      prefix = ""
    }
  }

  depends_on = [aws_s3_bucket_versioning.alb_log]
}

resource "aws_iam_role" "alb_log" {
  name = "s3-alb-log-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "alb_log" {
  role = aws_iam_role.alb_log.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.alb_log.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration"
        ]
        Resource = aws_s3_bucket.alb_log.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${var.alb_log_replica_bucket_arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket" "config" {
  bucket = "config.graduation-thesis.mc123004.sun.ac.jp"
}

resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.config.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSSL"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.config.arn,
          "${aws_s3_bucket.config.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "AWSConfigBucketCheck"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.config.arn
      },
      {
        Sid    = "AWSConfigBucketDelivery"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.config.arn}/AWSLogs/${var.aws_account_id}/Config/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "config" {
  bucket                  = aws_s3_bucket.config.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "config" {
  bucket = aws_s3_bucket.config.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 180
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "config" {
  role   = aws_iam_role.config.arn
  bucket = aws_s3_bucket.config.id

  rule {
    status   = "Enabled"
    priority = 1

    destination {
      bucket        = var.config_replica_bucket_arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Disabled"
    }

    filter {
      prefix = ""
    }
  }

  depends_on = [aws_s3_bucket_versioning.config]
}

resource "aws_iam_role" "config" {
  name = "s3-config-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "config" {
  role = aws_iam_role.config.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.config.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration"
        ]
        Resource = aws_s3_bucket.config.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "${var.config_replica_bucket_arn}/*"
      }
    ]
  })
}

resource "aws_kms_key" "this" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}
