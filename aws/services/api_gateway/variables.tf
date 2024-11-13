data "aws_cognito_user_pools" "this" {
  name = var.cognito_user_pool_name
}

variable "cognito_user_pool_name" {
  type = string
}

variable "get_tasks_by_user_id_lambda_invoke_arn" {
  type = string
}

variable "create_task_lambda_invoke_arn" {
  type = string
}

variable "delete_task_lambda_invoke_arn" {
  type = string
}

variable "waf_web_acl_arn" {
  type = string
}
