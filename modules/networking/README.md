# Networking Module

## Resources Created

- VPC
- Internet Gateway
- Public Subnets
- Public Route Table
- Route Table Associations

## Example

```hcl
module "networking" {

  source = "..."

  name = "example"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

}
```

## Outputs
Output	Description
vpc_id	VPC identifier
public_subnet_ids	Public subnet IDs
internet_gateway_id	Internet Gateway ID
public_route_table_id	Public route table ID