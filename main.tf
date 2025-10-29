resource "aws_iam_openid_connect_provider" "github_actions" {
  # This is the official URL for the GitHub Actions OIDC provider
  url = "https://token.actions.githubusercontent.com"

  # This is the required audience value for the OIDC provider
  client_id_list = ["sts.amazonaws.com"]

  # This is the fingerprint of the GitHub Actions OIDC provider's root certificate
  # It's a standard value provided by AWS documentation

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = var.tags
}

resource "aws_iam_role" "github_actions_oidc" {
  name = var.role_name

  # The trust policy that allows GitHub Actions to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            # This condition restricts the role to your specific GitHub repository
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
          }
        }
      }
    ]
  })

  # Attach the managed policies that you pass in as a variable
  managed_policy_arns = var.policy_arns

  tags = var.tags
}
