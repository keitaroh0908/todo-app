resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_flow_log" "name" {
  log_destination = aws_cloudwatch_log_group.this.arn
  iam_role_arn    = aws_iam_role.this.arn
  vpc_id          = aws_vpc.this.id
  traffic_type    = "REJECT"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/vpc/flow_logs/${var.environment}_vpc"
}

resource "aws_iam_role" "this" {
  name = "${var.environment}-flow-log-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  role = aws_iam_role.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}
