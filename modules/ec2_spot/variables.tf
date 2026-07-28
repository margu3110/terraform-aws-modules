variable "name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_profile_name" {
  type = string
}

variable "spot" {
  type    = bool
  default = true
}

variable "root_volume_size" {
  type    = number
  default = 30
}

variable "user_data" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(string)
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "market_type" {

  type = string

  default = "spot"

  validation {

    condition = contains(
      ["spot", "on-demand"],
      var.market_type
    )

    error_message = "market_type must be 'spot' or 'on-demand'."
  }

}

variable "ami_id" {
  description = "Optional custom AMI ID"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  type      = bool
  default   = true
}

variable "disable_api_termination" {
  type      = bool
  default   = false
}