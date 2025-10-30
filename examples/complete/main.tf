provider "aws" {
  region = local.region
}

locals {

  region               = "us-east-1"
  role_name            = "github-actions-oidc"
  role_description     = "IAM Role for GitHub Actions OIDC Federation"
  max_session_duration = 3600
  github_repositories  = ["drizzle-ai-systems/terraform-aws-oidc-github-actions"] # List of repositories or orgs

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" # Example policy ARN; replace with least privilege policies as needed                    
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1" # Current GitHub's OIDC thumbprint
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

  github_repositories  = local.github_repositories
  thumbprint_list      = local.thumbprint_list
  role_description     = local.role_description
  max_session_duration = local.max_session_duration
  role_name            = local.role_name
  policy_arns          = local.policy_arns
  tags                 = local.tags

}
