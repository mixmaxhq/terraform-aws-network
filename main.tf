## Networking

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  tags = {
    Name        = "${var.name}-${var.environment}"
    Service     = var.service
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.name}-${var.environment}"
    Service     = var.service
    Environment = var.environment
  }
}
