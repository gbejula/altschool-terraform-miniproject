terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "tera_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "tera_vpc"
  }
}

resource "aws_subnet" "tera-public-subnet1" {
  vpc_id = aws_vpc.tera_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "tera-public-subnet1"
  }
}

resource "aws_subnet" "tera-public-subnet2" {
  vpc_id = aws_vpc.tera_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "tera-public-subnet2"
  }
}

resource "aws_internet_gateway" "tera_interneet_gateway" {
  vpc_id = aws_vpc.tera_vpc.id
  tags = {
    Name = "tera_internet_gateway"
  }
}

resource "aws_route_table" "tera-route-table-public" {
  vpc_id = aws_vpc.tera_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tera_interneet_gateway.id
  }

  tags = {
    Name = "tera-route-table-public"
  }
}


resource "aws_route_table_association" "tera-public-subnet1-association" {
  subnet_id = aws_subnet.tera-public-subnet1.vpc_id
  route_table_id = aws_route_table.tera-route-table-public.id
}

resource "aws_route_table_association" "tera-public-subnet2-association" {
  subnet_id = aws_subnet.tera-public-subnet2.vpc_id
  route_table_id = aws_route_table.tera-route-table-public.id
}

resource "aws_network_acl" "tera-network-acl" {
  vpc_id = aws_vpc.tera_vpc.id
  subnet_ids = [aws_subnet.tera-public-subnet1.id, aws_subnet.tera-public-subnet2.id]

  ingress {
    rule_no = 100
    protocol = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }

  egress {
    rule_no = 100
    protocol = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
  }
}