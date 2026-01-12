resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "prod-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "az1" {}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "app_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zones[0]
}

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = var.availability_zones[0]
}

data "aws_availability_zones" "az2" {}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "app_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.az2.names[1]
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = data.aws_availability_zones.az2.names[1]
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "app_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table" "db_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "app_a" {
  subnet_id      = aws_subnet.app_a.id
  route_table_id = aws_route_table.app_private.id
}

resource "aws_route_table_association" "app_b" {
  subnet_id      = aws_subnet.app_b.id
  route_table_id = aws_route_table.app_private.id
}

resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.db_private.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.db_private.id
}
