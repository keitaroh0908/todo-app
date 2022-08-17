resource "aws_cloudfront_distribution" "this" {
  enabled = true

  origin {
    domain_name = var.images_bucket_regional_domain_name
    origin_id   = var.images_bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.this.id}"
    }
  }

  logging_config {
    include_cookies = false
    bucket          = var.logs_bucket_regional_domain_name
    prefix          = "cloudfront"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.images_bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "this" {}
