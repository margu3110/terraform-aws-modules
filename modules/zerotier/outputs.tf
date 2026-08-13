output "ssm_association_id" {
  description = "ID of the SSM association used to install ZeroTier."
  value       = aws_ssm_association.zerotier.association_id
}