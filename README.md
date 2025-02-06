# AWS S3 bucket terraform module

<!-- BEGIN_TF_DOCS -->
Creates s3 bucket with public access block, bucket policies, lifecycle policies, encryption, cors rules and website configuration

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_policies"></a> [bucket\_policies](#input\_bucket\_policies) | n/a | `list(map(any))` | `[]` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | n/a | <pre>list(<br/>    object({<br/>      allowed_headers = list(string)<br/>      allowed_methods = list(string)<br/>      allowed_origins = list(string)<br/>      expose_headers  = list(string)<br/>      max_age_seconds = number<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | n/a | <pre>object({<br/>    enabled = bool<br/>    key     = string<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "key": ""<br/>}</pre> | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | n/a | `bool` | `false` | no |
| <a name="input_lifecycle_policies"></a> [lifecycle\_policies](#input\_lifecycle\_policies) | n/a | `map(any)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_public"></a> [public](#input\_public) | n/a | `bool` | `false` | no |
| <a name="input_resource_policies"></a> [resource\_policies](#input\_resource\_policies) | n/a | `list(map(any))` | `[]` | no |
| <a name="input_website_documents"></a> [website\_documents](#input\_website\_documents) | n/a | <pre>object({<br/>    error = string<br/>    index = string<br/>  })</pre> | <pre>{<br/>  "error": "error.html",<br/>  "index": "index.html"<br/>}</pre> | no |
| <a name="input_website_enabled"></a> [website\_enabled](#input\_website\_enabled) | n/a | `bool` | `false` | no |
<!-- END_TF_DOCS -->