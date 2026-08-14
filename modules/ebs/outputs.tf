output "volume_id" {
  description = "EBS volume ID."
  value       = aws_ebs_volume.this.id
}

output "device_name" {
  description = "Device name attached to the EC2 instance."
  value       = var.device_name
}