resource "aws_iam_openid_connect_provider" "github_actions" {
  # This is the official URL for the GitHub Actions OIDC provider
  url = "https://token.actions.githubusercontent.com"

  # This is the required audience value for the OIDC provider
  client_id_list = ["sts.amazonaws.com"]

  # This is the fingerprint of the GitHub Actions OIDC provider's root certificate
  # It's a standard value provided by AWS documentation

  thumbprint_list = var.thumbprint_list

  tags = var.tags
}

data "aws_iam_policy_document" "oidc_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    condition {
      test = "StringLike"
      values = [
        for repo in var.github_repositories :
        "repo:${repo}:*"
      ]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

resource "aws_iam_role" "oidc_role" {
  name                 = var.role_name
  description          = var.role_description
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.oidc_role_assume_role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "oidc_role_attach_policies" {
  count = length(var.policy_arns)

  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.oidc_role.name

  depends_on = [aws_iam_role.oidc_role]
}
