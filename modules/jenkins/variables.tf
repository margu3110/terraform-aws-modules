variable "instance_id" {
  description = "ID of the EC2 instance where Jenkins will be installed."
  type        = string
}

variable "jenkins_port" {
  description = "TCP port on which Jenkins listens."
  type        = number
  default     = 8080
}