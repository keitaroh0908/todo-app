variable "aws_account_id" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "waf_web_acl_arn" {
  type = string
}
