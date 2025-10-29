# Complete AWS <TODO_EXPANDED> Example

Configuration in this directory deploys a complete example of the AWS OIDC GitHub Actions module with all available features enabled.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_gha_oidc"></a> [aws\_gha\_oidc](#module\_aws\_gha\_oidc) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_oidc_role_arn"></a> [github\_actions\_oidc\_role\_arn](#output\_github\_actions\_oidc\_role\_arn) | The ARN of the created IAM role for GitHub Actions. |
<!-- END_TF_DOCS -->
