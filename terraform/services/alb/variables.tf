variable "acm_certificate_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "s3_access_log_bucket_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "waf_web_acl_arn" {
  type = string
}
