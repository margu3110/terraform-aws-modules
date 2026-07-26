output "vpc_id" {
  value = aws_vpc.this.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  value = values(aws_subnet.public)[*].id
}

output "route_table_id" {
  value = aws_route_table.public.id
}