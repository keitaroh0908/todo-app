resource "aws_dynamodb_table" "this" {
  hash_key                    = "userId"
  range_key                   = "taskId"
  name                        = "tasks"
  billing_mode                = "PROVISIONED"
  read_capacity               = 5
  write_capacity              = 5
  deletion_protection_enabled = true

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "taskId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

resource "aws_backup_plan" "this" {
  name = "${aws_dynamodb_table.this.name}-table-backup-plan"

  rule {
    rule_name         = "backup-rule"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 12 * * ? *)"
    lifecycle {
      delete_after = 30
    }
  }
}

resource "aws_backup_vault" "this" {
  name        = "${aws_dynamodb_table.this.name}-table-backup-vault"
  kms_key_arn = aws_kms_key.this.arn
}

resource "aws_kms_key" "this" {
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_backup_selection" "this" {
  name         = "dynamodb-tables-backup-selection"
  plan_id      = aws_backup_plan.this.id
  iam_role_arn = var.backup_iam_role_arn

  resources = [
    aws_dynamodb_table.this.arn
  ]
}

resource "aws_appautoscaling_target" "read_capacity_units" {
  service_namespace  = "dynamodb"
  resource_id        = "table/${aws_dynamodb_table.this.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  min_capacity       = 5
  max_capacity       = 10
}

resource "aws_appautoscaling_policy" "read_capacity_units" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_capacity_units.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_capacity_units.resource_id
  scalable_dimension = aws_appautoscaling_target.read_capacity_units.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_capacity_units.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_target" "write_capacity_units" {
  service_namespace  = "dynamodb"
  resource_id        = "table/${aws_dynamodb_table.this.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  min_capacity       = 5
  max_capacity       = 10
}

resource "aws_appautoscaling_policy" "write_capacity_units" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_capacity_units.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_capacity_units.resource_id
  scalable_dimension = aws_appautoscaling_target.write_capacity_units.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_capacity_units.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}
