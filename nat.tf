## NATty stuff
resource "aws_eip" "nat" {
  count = local.az_count
  vpc   = true

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "nat-${var.name}-${var.environment}-${var.zone_ids[count.index]}"
    Service     = var.service
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat" {
  count         = local.az_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "nat-${var.name}-${var.environment}-${var.zone_ids[count.index]}"
    Service     = var.service
    Environment = var.environment
  }
}
