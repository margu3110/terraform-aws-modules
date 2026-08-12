variable "instance_id" {
  description = "ID of the EC2 instance where Ollama will be installed."
  type        = string
}

variable "ollama_version" {
  description = "Ollama version to install. Use latest for the current release."
  type        = string
  default     = "latest"
}

variable "listen_address" {
  description = "Address and port where Ollama listens."
  type        = string
  default     = "0.0.0.0:11434"
}

variable "tags" {
  description = "Tags applied to resources created by the module."
  type        = map(string)
  default     = {}
}