module "createTask" {
  source = "../../elements/lambda/function"

  function_name       = "createTask"
  account_id          = var.account_id
  dynamodb_table_name = var.dynamodb_table_name
}

module "getTask" {
  source = "../../elements/lambda/function"

  function_name       = "getTask"
  account_id          = var.account_id
  dynamodb_table_name = var.dynamodb_table_name
}

module "setTaskCompletion" {
  source = "../../elements/lambda/function"

  function_name       = "setTaskCompletion"
  account_id          = var.account_id
  dynamodb_table_name = var.dynamodb_table_name
}

module "updateTaskTitle" {
  source = "../../elements/lambda/function"

  function_name       = "updateTaskTitle"
  account_id          = var.account_id
  dynamodb_table_name = var.dynamodb_table_name
}
