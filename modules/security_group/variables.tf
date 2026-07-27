variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  description = "Ingress rules"

  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_ipv4   = string
  }))

  default = {}
}

variable "egress_rules" {
  description = "Egress rules"

  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_ipv4   = string
  }))

  default = {}
}

variable "tags" {
  type = map(string)
}