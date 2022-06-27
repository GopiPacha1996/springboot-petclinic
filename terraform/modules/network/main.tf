resource "aws_vpc" "demo-vpc" {
cidr_block = var.vpc_cdr
tags = {
  Name= "${var.env}-vpc"
}
}
resource "aws_subnet" "demoSubnet"{
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env}-subnet"
}
}

resource "aws_internet_gateway" "demo-ig"{
    vpc_id = aws_vpc.demo-vpc.id
    tags = {
        Name = "${var.env}-igw"
    }
}

resource "aws_default_route_table" "demo-rt" {
    default_route_table_id = aws_vpc.demo-vpc.default_route_table_id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-ig.id
  }
  tags = {
      Name = "${var.env}-rt"
  }
}

resource "aws_route_table_association" "rt-sub" {
    subnet_id = aws_subnet.demoSubnet.id
    route_table_id = aws_default_route_table.demo-rt.id
}
