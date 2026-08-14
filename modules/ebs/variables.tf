variable "name" {
  description = "Name of the EBS volume."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone where the EBS volume will be created."
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to attach the volume to."
  type        = string
}

variable "size" {
  description = "EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "type" {
  description = "EBS volume type."
  type        = string
  default     = "gp3"
}

variable "device_name" {
  description = "Device name presented to the EC2 instance."
  type        = string
  default     = "/dev/sdf"
}

variable "encrypted" {
  description = "Whether to encrypt the EBS volume."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the EBS volume."
  type        = map(string)
  default     = {}
}