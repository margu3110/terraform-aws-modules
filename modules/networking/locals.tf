locals {

  public_subnets = {
    for index, cidr in var.public_subnet_cidrs :
    index => cidr
  }

}