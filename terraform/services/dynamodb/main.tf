resource "aws_dynamodb_table" "this" {
  hash_key       = "userId"
  range_key      = "taskId"
  name           = "tasks"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "taskId"
    type = "S"
  }
}
