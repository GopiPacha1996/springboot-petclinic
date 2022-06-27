output vpc_id {
    value = aws_vpc.demo-vpc.id
}
output subnet_id {
    value = aws_subnet.demoSubnet.id
}