data "archive_file" "this" {
  type        = "zip"
  source_file = "./source/${var.function_name}/index.js"
  output_path = "./dist/${var.function_name}.zip"
}

variable "function_name" {
  type = string
}

variable "account_id" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}
