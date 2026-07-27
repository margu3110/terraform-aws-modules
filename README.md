# Terraform AWS Modules

Reusable Terraform modules for AWS infrastructure.

## Available Modules

| Module | Status |
|---------|--------|
| networking | 🚧 |
| security_group | 🚧 |
| ec2_spot | 🚧 |
| iam | 🚧 |

## Versioning

This repository follows Semantic Versioning.

Example:

```hcl
module "networking" {

  source = "git::ssh://git@github.com/margu3110/terraform-aws-modules.git//modules/networking?ref=v1.0.0"

}
```

## Requirements

- Terraform >= 1.15
- AWS Provider 6.x