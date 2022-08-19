resource "aws_dynamodb_table" "this" {
  hash_key       = "UserId"
  range_key      = "TaskId"
  name           = "Task"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "TaskId"
    type = "S"
  }
}
