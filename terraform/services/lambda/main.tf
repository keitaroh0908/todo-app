module "create_task" {
  source = "../../elements/lambda/function"

  function_name       = "createTask"
  account_id          = var.account_id
  dynamodb_table_name = var.dynamodb_table_name
}

module "get_tasks_by_user_id" {
  source = "../../elements/lambda/function"

  function_name       = "getTasksByUserId"
  account_id          = var.account_id
  dynamodb_table_name = var.dynamodb_table_name
}

module "delete_task" {
  source = "../../elements/lambda/function"

  function_name       = "deleteTask"
  account_id          = var.account_id
  dynamodb_table_name = var.dynamodb_table_name
}
