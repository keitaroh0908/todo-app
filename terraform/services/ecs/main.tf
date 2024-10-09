resource "aws_ecs_cluster" "this" {
  name = "graduation-thesis"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "this" {
  name                 = "app"
  cluster              = aws_ecs_cluster.this.id
  task_definition      = data.aws_ecs_task_definition.this.arn
  force_new_deployment = true
  desired_count        = 1
  launch_type          = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.this.id]
  }

  load_balancer {
    container_name   = "app"
    container_port   = 80
    target_group_arn = var.target_group_arn
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "app"
  task_role_arn            = aws_iam_role.this.arn
  execution_role_arn       = aws_iam_role.this.arn
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${var.ecr_repository_url}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          hostPort      = 80
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver     = "awslogs"
        secretOptions = null
        options = {
          "awslogs-group"         = "/ecs/app"
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "app"
        }
      }
      readOnlyRootFilesystem = true
    }
  ])
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/app"
}

resource "aws_iam_role" "this" {
  name = "ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_security_group" "this" {
  name   = "ecs_app"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "TCP"
  source_security_group_id = var.alb_security_group_id
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
