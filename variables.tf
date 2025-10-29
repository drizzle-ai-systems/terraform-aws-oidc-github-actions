variable "aws_account_id" {
  description = "The AWS account ID where the role will be created."
  type        = string
}

variable "github_org" {
  description = "The name of your GitHub organization / User Name."
  type        = string
}

variable "github_repo" {
  description = "The name of your GitHub repository."
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role."
  type        = string
  default     = "github-actions-oidc-role"
}

variable "policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role. You almost always want to attach policies"
  type        = list(string)
  # It's good practice to provide a default, but for a role,
  # you almost always want to attach policies.
  default = []
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the object. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}
