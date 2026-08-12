output "ssm_association_id" {
  description = "ID of the SSM association used to install Ollama."
  value       = aws_ssm_association.ollama.association_id
}

output "listen_address" {
  description = "Address where Ollama is configured to listen."
  value       = var.listen_address
}