variable "github_repositories" {
  description = "GitHub repository identifiers in the format 'org/repo' or 'org/*' for all repositories in an organization. Supports single or multiple repositories/orgs."
  type        = list(string)
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) for the IAM role."
  type        = number
  default     = 3600
}

variable "policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role. You almost always want to attach policies"
  type        = list(string)
  # It's good practice to provide a default, but for a role,
  # you almost always want to attach policies.
  default = []
}

variable "role_description" {
  description = "The description of the OIDC Github Actions IAM role."
  type        = string
  default     = "IAM role for GitHub Actions OIDC federation"
}

variable "role_name" {
  description = "The name of the IAM role."
  type        = string
  default     = "github-actions-oidc-role"
}

variable "tags" {
  description = "(Optional) A map of tags to assign to the object. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "thumbprint_list" {
  description = "A list of thumbprints for the OIDC provider."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # Current GitHub's OIDC thumbprint
}
