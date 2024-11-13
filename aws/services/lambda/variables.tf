variable "account_id" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "api_gateway_execution_arn" {
  type = string
}

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}
