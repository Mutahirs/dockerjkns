provider "aws" {
  region = "us-east-1"
}

#data "aws_availability_zones" "available_zones" {
 # state = "available"
#}

#aws_vpc
resource "aws_vpc" "red" {
  cidr_block = "10.20.0.0/16"
   tags = {
    Name = "red-vpc"
  }
}
#sub-nets
resource "aws_subnet" "public" {
  count                   = "${length(var.subnets_cidr)}"
  cidr_block              = "${element(var.subnets_cidr,count.index)}"
  availability_zone       = "${element(var.azs,count.index)}"
  vpc_id                  = aws_vpc.red.id
  map_public_ip_on_launch = true
}

#aws_internet_gateway

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.red.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.red.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_security_group" "red_sg" {
  name        = "red-sg"
  description = "Security group for instance"
  vpc_id      = aws_vpc.red.id

  tags = {
      Name = "red-inst-sg"
        }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

