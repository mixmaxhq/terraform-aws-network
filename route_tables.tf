# Route table configuration

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "public-${var.name}-${var.environment}"
    Environment = var.environment
    Service     = var.service
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = local.az_count
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  # We create one private route table per AZ to give us access
  # to a local NAT for durability
  count  = local.az_count
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "private-${var.name}-${var.environment}-${var.zone_ids[count.index]}"
    Environment = var.environment
    Service     = var.service
  }
}

resource "aws_route" "private_internet" {
  # We create one route per each table in each AZ to use the local NAT.
  count                  = local.az_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = local.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# The data tier has no access to the public internet. Please
# deliver updates via managed service mechanisms, swapping AMIs,
# or using some intermediary within the private subnets.
resource "aws_route_table" "data" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "data-${var.name}-${var.environment}"
    Environment = var.environment
    Service     = var.service
  }
}

resource "aws_route_table_association" "data" {
  count          = local.az_count
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.data.id
}
