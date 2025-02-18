output "vpc_id" {
  value       = aws_vpc.main.id  
}
output "igw_id" {
  value       = aws_internet_gateway.main.id  
}
output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
    value = aws_subnet.private[*].id
}
output "database_subnet_ids" {
    value = aws_subnet.private[*].id
}
output "db_subnet_group_arn" {
    value = aws_db_subnet_group.db_group.arn
}
output "nat_gateway_id" {
    value = aws_nat_gateway.main.id
}
output "public_route_table_id" {
    value  = aws_route_table.public.id
}
output "private_route_table_id" {
    value  = aws_route_table.private.id
}
output "database_route_table_id" {
    value  = aws_route_table.database.id
}
output "default_vpc" {
    value = data.aws_vpc.default.cidr_block
}
output "db_subnet_group_name" {
    value = aws_db_subnet_group.db_group.id
}
