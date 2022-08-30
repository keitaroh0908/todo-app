resource "aws_api_gateway_method" "this" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = var.http_method
  authorization = var.authorization
  authorizer_id = var.authorizer_id
}
