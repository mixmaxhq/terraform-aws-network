# Subnet configuration

# Assuming we are deploying /21s to 3 AZs, the below configuration uses less than
# a quarter of the available addresses in the VPC's /16.

resource "aws_subnet" "public" {
  count  = local.az_count
  vpc_id = aws_vpc.vpc.id

  # The below will spread the public subnets across each AZ
  availability_zone_id = var.zone_ids[count.index]

  # Assuming the referenced VPC is a /16, the below will
  # give us a /21 (2046 usable IPs) in the first available blocks
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 5, count.index)

  tags = {
    Name        = "public-${var.name}-${var.environment}-${var.zone_ids[count.index]}"
    Service     = var.service
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  count  = local.az_count
  vpc_id = aws_vpc.vpc.id

  # The below will spread the public subnets across each AZ
  availability_zone_id = var.zone_ids[count.index]

  # Assuming the referenced VPC is a /16, the below will
  # give us a /21 (2046 usable IPs). These block start six /21s
  # into the VPC to allow us to scale out the public subnets/zones
  # up to 6.
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 5, 6 + count.index)

  tags = {
    Name        = "private-${var.name}-${var.environment}-${var.zone_ids[count.index]}"
    Service     = var.service
    Environment = var.environment
  }
}

resource "aws_subnet" "data" {
  count  = local.az_count
  vpc_id = aws_vpc.vpc.id

  # The below will spread the public subnets across each AZ
  availability_zone_id = var.zone_ids[count.index]

  # Assuming the referenced VPC is a /16, the below will
  # give us a /21 (2046 usable IPs). These blocks start 12 /21s
  # into the VPC to allow us to scale out the public & private 
  # subnets/zones up to 6.
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 5, 12 + count.index)

  tags = {
    Name        = "data-${var.name}-${var.environment}-${var.zone_ids[count.index]}"
    Service     = var.service
    Environment = var.environment
  }
}
