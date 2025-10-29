output "github_actions_oidc_role_arn" {
  description = "The ARN of the created IAM role for GitHub Actions."
  value       = module.aws_gha_oidc.role_arn
}
