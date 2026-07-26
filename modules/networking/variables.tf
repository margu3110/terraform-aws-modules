variable "name" {
  description = "Resource prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to resources"
  type        = map(string)
  default     = {}
}