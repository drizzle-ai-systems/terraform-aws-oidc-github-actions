provider "aws" {
  region = local.region
}

locals {

  region      = "us-east-1"
  account_id  = "123456789012" # Replace with your AWS Account ID
  role_name   = "github-actions-oidc"
  github_org  = "drizzle-ai-systems"
  github_repo = "terraform-aws-oidc-github-actions"

  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess" # Example policy ARN; replace with least privilege policies as needed                    
  ]

  tags = {
    Example    = local.role_name
    GithubRepo = "terraform-aws-oidc-github-actions"
    GithubOrg  = "drizzle-ai-systems"
  }

}

################################################################################
# AWS GitHub Actions OIDC Module
################################################################################

module "aws_gha_oidc" {
  source = "../../"

  aws_account_id = local.account_id
  github_org     = local.github_org
  github_repo    = local.github_repo
  role_name      = local.role_name
  policy_arns    = local.policy_arns
  tags           = local.tags

}
