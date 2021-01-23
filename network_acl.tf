# This Network ACL permits inbound and outbound from the `data` subnets
# to only the `private` and `data` subnets. AWS creates a default "catch-all"
# rule to deny all access to a destination otherwise not defined.
resource "aws_network_acl" "data" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = aws_subnet.data.*.id

  tags = {
    Name        = "data-${var.name}-${var.environment}"
    Service     = var.service
    Environment = var.environment
  }
}

resource "aws_network_acl_rule" "allow_data_from_data_ingress" {
  count          = length(aws_subnet.data)
  network_acl_id = aws_network_acl.data.id
  # we leave some space between rule numbers for custom rules
  rule_number = 50 + (count.index * 5)
  egress      = false
  protocol    = -1
  rule_action = "allow"
  cidr_block  = aws_subnet.data[count.index].cidr_block
}

resource "aws_network_acl_rule" "allow_data_to_data_egress" {
  count          = length(aws_subnet.data)
  network_acl_id = aws_network_acl.data.id
  # we leave some space between rule numbers for custom rules
  rule_number = 50 + (count.index * 5)
  egress      = true
  protocol    = -1
  rule_action = "allow"
  cidr_block  = aws_subnet.data[count.index].cidr_block
}

resource "aws_network_acl_rule" "allow_data_from_private_ingress" {
  count          = length(aws_subnet.private)
  network_acl_id = aws_network_acl.data.id
  # we leave some space between rule numbers for custom rules
  rule_number = 100 + (count.index * 5)
  egress      = false
  protocol    = -1
  rule_action = "allow"
  cidr_block  = aws_subnet.private[count.index].cidr_block
}

resource "aws_network_acl_rule" "allow_data_to_private_egress" {
  count          = length(aws_subnet.private)
  network_acl_id = aws_network_acl.data.id
  # we leave some space between rule numbers for custom rules
  rule_number = 100 + (count.index * 5)
  egress      = true
  protocol    = -1
  rule_action = "allow"
  cidr_block  = aws_subnet.private[count.index].cidr_block
}
