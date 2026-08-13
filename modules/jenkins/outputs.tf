output "association_id" {
  description = "SSM association ID used to install Jenkins."
  value       = aws_ssm_association.jenkins.association_id
}