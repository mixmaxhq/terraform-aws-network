output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the created VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  description = "A list of the public subnet IDs"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "A list of the private subnet IDs"
  value       = aws_subnet.private.*.id
}

output "data_subnet_ids" {
  description = "A list of the data subnet IDs"
  value       = aws_subnet.public.*.id
}

output "data_network_acl_id" {
  description = "The ID of the network ACL applied to the data subnets. Useful for defining custom network ACL rules"
  value       = aws_network_acl.data.id
}
