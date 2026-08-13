variable "instance_id" {
  description = "ID of the EC2 instance where ZeroTier will be installed."
  type        = string
}

variable "network_id" {
  description = "ZeroTier network ID to join."
  type        = string
}