resource "aws_ecr_repository" "this" {
  name                 = "todo-app"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
