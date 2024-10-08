resource "aws_api_gateway_rest_api" "this" {
  name = "task_api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.this.arn
}

resource "aws_api_gateway_authorizer" "this" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  provider_arns = data.aws_cognito_user_pools.this.arns
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(file("./services/api_gateway/main.tf"))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  stage_name    = "production"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id

  depends_on = [
    aws_cloudwatch_log_group.this
  ]
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_iam_role" "this" {
  name = "api_gateway_logging_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.this.id}/production"
  retention_in_days = 7
}

# Path: /tasks
module "resource_tasks" {
  source = "../../elements/api_gateway/resource"

  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "tasks"
}

# Method: GET
module "method_get_tasks" {
  source = "../../elements/api_gateway/method"

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = module.resource_tasks.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

module "integration_get_tasks" {
  source = "../../elements/api_gateway/integration"

  rest_api_id       = aws_api_gateway_rest_api.this.id
  resource_id       = module.resource_tasks.id
  http_method       = module.method_get_tasks.http_method
  lambda_invoke_arn = var.get_tasks_by_user_id_lambda_invoke_arn
}

# Method: POST
module "method_post_tasks" {
  source = "../../elements/api_gateway/method"

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = module.resource_tasks.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

module "integration_post_tasks" {
  source = "../../elements/api_gateway/integration"

  rest_api_id       = aws_api_gateway_rest_api.this.id
  resource_id       = module.resource_tasks.id
  http_method       = module.method_post_tasks.http_method
  lambda_invoke_arn = var.create_task_lambda_invoke_arn
}

# Method: DELETE

module "method_delete_tasks" {
  source = "../../elements/api_gateway/method"

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = module.resource_tasks.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

module "integration_delete_tasks_taskId" {
  source = "../../elements/api_gateway/integration"

  rest_api_id       = aws_api_gateway_rest_api.this.id
  resource_id       = module.resource_tasks.id
  http_method       = module.method_delete_tasks.http_method
  lambda_invoke_arn = var.delete_task_lambda_invoke_arn
}

# Method: OPTIONS
module "method_options_tasks" {
  source = "../../elements/api_gateway/preflight/method"

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = module.resource_tasks.id
}

module "method_response_options_task" {
  source = "../../elements/api_gateway/preflight/method_response"

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = module.resource_tasks.id
  http_method = module.method_options_tasks.http_method
}

module "integration_response_options_task" {
  source = "../../elements/api_gateway/preflight/integration_response"

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = module.resource_tasks.id
  http_method = module.method_options_tasks.http_method
  status_code = module.method_response_options_task.status_code
}

module "integration_options_task" {
  source = "../../elements/api_gateway/preflight/integration"

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = module.resource_tasks.id
  http_method = module.method_options_tasks.http_method
}
