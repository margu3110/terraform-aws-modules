variable "instance_id" {
  description = "ID of the EC2 instance where Jenkins will be installed."
  type        = string
}

variable "jenkins_port" {
  description = "TCP port on which Jenkins listens."
  type        = number
  default     = 8080
}

variable "jenkins_data_device" {
  description = "Block device containing persistent Jenkins data."
  type        = string
  default     = ""
}

variable "jenkins_data_mount_point" {
  description = "Mount point for persistent Jenkins data."
  type        = string
  default     = "/var/lib/jenkins"
}