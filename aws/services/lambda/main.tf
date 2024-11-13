module "create_task" {
  source = "../../elements/lambda/function"

  function_name             = "createTask"
  account_id                = var.account_id
  dynamodb_table_name       = var.dynamodb_table_name
  api_gateway_execution_arn = var.api_gateway_execution_arn
  vpc_subnet_ids            = var.vpc_subnet_ids
  security_group_id         = aws_security_group.this.id
}

module "get_tasks_by_user_id" {
  source = "../../elements/lambda/function"

  function_name             = "getTasksByUserId"
  account_id                = var.account_id
  dynamodb_table_name       = var.dynamodb_table_name
  api_gateway_execution_arn = var.api_gateway_execution_arn
  vpc_subnet_ids            = var.vpc_subnet_ids
  security_group_id         = aws_security_group.this.id
}

module "delete_task" {
  source = "../../elements/lambda/function"

  function_name             = "deleteTask"
  account_id                = var.account_id
  dynamodb_table_name       = var.dynamodb_table_name
  api_gateway_execution_arn = var.api_gateway_execution_arn
  vpc_subnet_ids            = var.vpc_subnet_ids
  security_group_id         = aws_security_group.this.id
}

resource "aws_security_group" "this" {
  name   = "lambda-security-group"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.vpc_cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
