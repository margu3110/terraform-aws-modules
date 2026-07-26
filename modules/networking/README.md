# Networking Module

Creates:

- VPC
- Internet Gateway
- Public Subnets
- Public Route Table

## Inputs

- name
- vpc_cidr
- public_subnet_cidrs
- tags

## Outputs

- vpc_id
- public_subnet_ids
- internet_gateway_id
- route_table_id