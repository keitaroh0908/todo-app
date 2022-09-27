module "create_task" {
  source = "../../elements/lambda/function"

  function_name             = "createTask"
  account_id                = var.account_id
  dynamodb_table_name       = var.dynamodb_table_name
  api_gateway_execution_arn = var.api_gateway_execution_arn
}

module "get_tasks_by_user_id" {
  source = "../../elements/lambda/function"

  function_name             = "getTasksByUserId"
  account_id                = var.account_id
  dynamodb_table_name       = var.dynamodb_table_name
  api_gateway_execution_arn = var.api_gateway_execution_arn
}

module "delete_task" {
  source = "../../elements/lambda/function"

  function_name             = "deleteTask"
  account_id                = var.account_id
  dynamodb_table_name       = var.dynamodb_table_name
  api_gateway_execution_arn = var.api_gateway_execution_arn
}
