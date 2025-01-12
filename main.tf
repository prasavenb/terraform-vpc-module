resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    var.common_tags,
    {
        Name = local.resource_name
    }
  )
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  
  tags = merge(
    var.common_tags,
    {
        Name  = local.resource_name
    }
  )
}
resource "aws_subnet" "public" {
    count = length(var.public_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )  
}
resource "aws_subnet" "private" {
    count = length(var.private_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )  
}
resource "aws_subnet" "database" {
    count = length(var.database_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )  
}
resource "aws_db_subnet_group" "database_group" {
  name       = "${local.resource_name}-database"
  subnet_ids = aws_subnet.database[*].id
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-database"
    }
  )
}
resource "aws_eip" "my_ip" {  
  domain   = "vpc"
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-eip"
    }
  )
}
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.my_ip.id
  subnet_id     = aws_subnet.public[0].id
  depends_on = [aws_internet_gateway.main]
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-nat"
    }
  )
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id  
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-public_table"
    }
  )  
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id  
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-private_table"
    }
  )  
}
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id  
  tags = merge(
    var.common_tags,
    {
        Name = "${local.resource_name}-database_table"
    }
  )  
}
resource "aws_route" "public" {    
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.main.id
}
resource "aws_route" "private_nat" {    
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}
resource "aws_route" "database_nat" {    
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}
resource "aws_route_table_association" "public" {
    count = length(var.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
    count = length(var.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "database" {
    count = length(var.database_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

