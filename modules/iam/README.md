# IAM Module

## Creates

- IAM Role
- IAM Instance Profile
- Managed Policy Attachments

## Example

```hcl
module "iam" {
  source = "..."

  name = "ia-lab"

  assume_role_policy = data.aws_iam_policy_document.ec2.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = local.tags
}
```

## Outputs

- role_name
- role_arn
- instance_profile_name
- instance_profile_arn