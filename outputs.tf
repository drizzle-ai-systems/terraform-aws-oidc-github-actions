output "role_arn" {
  description = "The ARN of the created IAM role for GitHub Actions."
  value       = aws_iam_role.oidc_role.arn
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}
