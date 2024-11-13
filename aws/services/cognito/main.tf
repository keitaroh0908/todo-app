resource "aws_cognito_user_pool" "this" {
  name = "task_user_pool"
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "task_user_pool_client"
  user_pool_id = aws_cognito_user_pool.this.id
}

resource "aws_cognito_identity_pool" "this" {
  identity_pool_name               = "task_identity_pool"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.this.id
    provider_name           = aws_cognito_user_pool.this.endpoint
    server_side_token_check = false
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "this" {
  identity_pool_id = aws_cognito_identity_pool.this.id
  roles = {
    "authenticated"   = aws_iam_role.authenticated.arn
    "unauthenticated" = aws_iam_role.unauthenticated.arn
  }
}

resource "aws_iam_role" "unauthenticated" {
  name = "cogntio_unauthenticated_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.this.id
          }
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "unauthenticated"
          }
        }
        Effect = "Allow"
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "authenticated" {
  name = "cognito_authenticated_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "cognito-identity.amaonaws.com:aud" = aws_cognito_identity_pool.this.id
          }
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "authenticated"
          }
        }
        Effect = "Allow"
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        }
      }
    ]
  })
}
