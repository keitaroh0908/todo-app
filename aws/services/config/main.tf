resource "aws_iam_service_linked_role" "this" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = var.s3_delivery_channel_bucket_name
}

resource "aws_config_configuration_recorder" "this" {
  role_arn = aws_iam_service_linked_role.this.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
    resource_types                = []
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = "default"
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.this
  ]
}
