provider "aws" {
  region = var.region
  }
terraform {
  backend "s3" {}
}
resource "aws_vpc" "production_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Production-VPC"
  }
}

resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.public_subnet_cidr1
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "us-west-2a"

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.public_subnet_cidr2
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "us-west-2b"

  tags = {
    Name = "public-subnet-2"
  }
}
resource "aws_subnet" "public-subnet-3" {
  cidr_block        = var.public_subnet_cidr3
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "us-west-2c"
  tags              = {
    Name = "public-subnet-3"

  }
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block        = var.private_subnet_cidr1
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "us-west-2a"

  tags = {
    Name = "private subnet 1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  cidr_block        = var.private_subnet_cidr2
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "us-west-2b"

  tags = {

    Name = "Private Subnet 2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  cidr_block        = var.private_subnet_cidr3
  vpc_id            = aws_vpc.production_vpc.id
  availability_zone = "us-west-2c"

  tags = {

    Name = "Private Subnet 3"
  }
}

resource "aws_route_table" "public_route-table" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "public route table"
  }
}

resource "aws_route_table" "private_route-table" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "Private Route table"
  }
}

resource "aws_route_table_association" "public_subnet1_association" {
  route_table_id = aws_route_table.public_route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  route_table_id = aws_route_table.public_route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "public_subnet3_association" {
  route_table_id = aws_route_table.public_route-table.id
  subnet_id      = aws_subnet.public-subnet-3.id
}

resource "aws_route_table_association" "private_subnet1_association" {
  route_table_id = aws_route_table.private_route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private_subnet2_association" {
  route_table_id = aws_route_table.private_route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

resource "aws_route_table_association" "private_subnet3_association" {
  route_table_id = aws_route_table.private_route-table.id
  subnet_id      = aws_subnet.private-subnet-3.id
}

resource "aws_eip" "elastic-ip-for-nat-gateway" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Production-Ip"
  }

}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gateway.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "production NAT Gateway"
  }

  depends_on = ["aws_eip.elastic-ip-for-nat-gateway"]
}

resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private_route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "production-gateway" {
 vpc_id = aws_vpc.production_vpc.id
 tags = {
   Name = "Production-IGW"
 }

}

resource "aws_route" "public-internet-gateway-route" {
  route_table_id         = aws_route_table.public_route-table.id
  gateway_id             = aws_internet_gateway.production-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}



