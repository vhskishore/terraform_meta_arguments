resource "aws_vpc" "metaargs-aws_vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name : "${var.vpcName}"
  }
}

resource "aws_subnet" "pub-metaargs-sn" {
  vpc_id                  = aws_vpc.metaargs-aws_vpc.id
  cidr_block              = var.pubsncidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pri-metaargs-sn" {
  vpc_id            = aws_vpc.metaargs-aws_vpc.id
  cidr_block        = var.prisncidr
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "metaargs-igw" {
  vpc_id = aws_vpc.metaargs-aws_vpc.id
  tags = {
    Name : "MetaArgs-IGW"
  }
}
resource "aws_route_table" "pub-metaargs-rt" {
  vpc_id = aws_vpc.metaargs-aws_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.metaargs-igw.id
  }
  tags = {
    Name : "Pub-RT"
  }
}

resource "aws_route_table" "pri-metaargs-rt" {
  vpc_id = aws_vpc.metaargs-aws_vpc.id
}

resource "aws_route_table_association" "pub-rt-aso-metaargs" {
  subnet_id      = aws_subnet.pub-metaargs-sn.id
  route_table_id = aws_route_table.pub-metaargs-rt.id
}