# AWS OpenID Connect for Github Action Terraform module

This Terraform module provisions AWS OpenID Connect (OIDC) identity provider and IAM roles to enable secure, keyless authentication between GitHub Actions workflows and AWS services. By using OIDC, you can eliminate the need to store long-lived AWS credentials as GitHub secrets, improving security and following AWS best practices.

The module creates the necessary AWS resources to establish trust between GitHub's OIDC provider and your AWS account, allowing GitHub Actions to assume IAM roles and access AWS services during workflow execution. This approach provides temporary, scoped credentials that are automatically rotated and follow the principle of least privilege.

## Key Features

- Creates AWS OIDC identity provider for GitHub Actions
- Configures IAM roles with customizable trust policies
- Supports multiple GitHub repositories and organizations
- Enables secure, temporary credential access without stored secrets
- Follows AWS security best practices for CI/CD authentication

## Example to use the new role with your Github Actions Pipelines / Workflows

```yaml
name: AWS ECR Pipeline

on:
  push:
    branches:
      - main
      - feat.*

jobs:
  deploy:
    name: deploy
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ vars.AWS_ROLE_TO_ASSUME }} # OIDC Role ARN
          aws-region: us-west-2

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v2

      ... # 
```

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-oidc-github-actions/tree/main/examples) directory for working examples to reference:

```hcl
locals {

  region               = "us-west-2"
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

```

## Examples

Examples codified under the [`examples`](https://github.com/drizzle-ai-systems/terraform-aws-oidc-github-actions/tree/main/examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](https://github.com/drizzle-ai-systems/terraform-aws-oidc-github-actions/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.oidc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.oidc_role_attach_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.oidc_role_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | GitHub repository identifiers in the format 'org/repo' or 'org/*' for all repositories in an organization. Supports single or multiple repositories/orgs. | `list(string)` | n/a | yes |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | The maximum session duration (in seconds) for the IAM role. | `number` | `3600` | no |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | A list of IAM policy ARNs to attach to the role. You almost always want to attach policies | `list(string)` | `[]` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | The description of the OIDC Github Actions IAM role. | `string` | `"IAM role for GitHub Actions OIDC federation"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the IAM role. | `string` | `"github-actions-oidc-role"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the object. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_thumbprint_list"></a> [thumbprint\_list](#input\_thumbprint\_list) | A list of thumbprints for the OIDC provider. | `list(string)` | <pre>[<br/>  "6938fd4d98bab03faadb97b34396831e3780aea1"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | OIDC provider ARN |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the created IAM role for GitHub Actions. |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-<TODO>/blob/main/LICENSE).
