# AWS OpenID Connect for Github Action Terraform module

This Terraform module provisions AWS OpenID Connect (OIDC) identity provider and IAM roles to enable secure, keyless authentication between GitHub Actions workflows and AWS services. By using OIDC, you can eliminate the need to store long-lived AWS credentials as GitHub secrets, improving security and following AWS best practices.

The module creates the necessary AWS resources to establish trust between GitHub's OIDC provider and your AWS account, allowing GitHub Actions to assume IAM roles and access AWS services during workflow execution. This approach provides temporary, scoped credentials that are automatically rotated and follow the principle of least privilege.

## Key Features

- Creates AWS OIDC identity provider for GitHub Actions
- Configures IAM roles with customizable trust policies
- Supports multiple GitHub repositories and organizations
- Enables secure, temporary credential access without stored secrets
- Follows AWS security best practices for CI/CD authentication

## Example to use the new role wiht your Github Actions Pipelines / Workflows

```yaml
name: Terraform Github Actions Pipeline

on:
  workflow_call:
    inputs:
env:

  TF_LOG: INFO
    AWS_REGION: <your_aws_region>
    AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }} 
    ROLE_NAME: ${{ secrets.ROLE_NAME }} # The OIDC gha role name created by this module - add as a GitHub repository secret


jobs:
  terraform:
    name: deploy
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ${{ inputs.working-directory }}

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        role-to-assume: arn:aws:iam::${{ env.AWS_ACCOUNT_ID }}:role/${{ env.ROLE_NAME }} # your OIDC role now used for secure AWS authentication
          aws-region: ${{ env.AWS_REGION }}

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: 1.9.0

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      id: plan
      run: terraform plan -no-color -out=tf.plan
      ... # 
```

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-oidc-github-actions/tree/main/examples) directory for working examples to reference:

```hcl
module "oidc_github_actions" {
  source = "drizzle-ai-systems/oidc-github-actions/aws"

  region      = "us-east-1"
  account_id  = "123456789012" # Replace with your AWS Account ID
  role_name   = "github-actions-oidc"
  github_org  = "drizzle-ai-systems" # Replace with your Github Org name or your Github User Name
  github_repo = "terraform-aws-oidc-github-actions" # Replace with your Githu repository name

  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess" # Example policy ARN; replace with least privilege policies as needed                    
  ]
  
  # Use your own tags
  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-oidc-github-actions"
    GithubOrg  = "drizzle-ai-systems"
  }
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
| [aws_iam_role.github_actions_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where the role will be created. | `string` | n/a | yes |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | The name of your GitHub organization / User Name. | `string` | n/a | yes |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | The name of your GitHub repository. | `string` | n/a | yes |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | A list of IAM policy ARNs to attach to the role. You almost always want to attach policies | `list(string)` | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the IAM role. | `string` | `"github-actions-oidc-role"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the object. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The ARN of the created IAM role for GitHub Actions. |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-<TODO>/blob/main/LICENSE).
