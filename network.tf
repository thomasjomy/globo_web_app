provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}


#data
data "aws_availability_zones" "available" {
  state = "available"
}

## Resources

#Networking
resource "aws_vpc" "app" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = local.common_tags
}


resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
  tags   = local.common_tags

}

resource "aws_subnet" "public_subnet_1" {
  cidr_block              = var.vpc_public_subnets_cidr_block[0]
  vpc_id                  = aws_vpc.app.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = local.common_tags
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block              = var.vpc_public_subnets_cidr_block[1]
  vpc_id                  = aws_vpc.app.id
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = local.common_tags
}



# Routing
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block           = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.app.vpc_id

}

resource "aws_route_table_association" "app_subnet2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.app.vpc_id
}

## Security Groups
resource "aws_security_group" "nginx_sg" {
  name   = "ngnix_sg"
  vpc_id = aws_vpc.app.id

  #HTTP access from anywhere
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  #Outbound internet access
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}


resource "aws_security_group" "alb_sg" {
  name   = "alb_ngnix_sg"
  vpc_id = aws_vpc.app.id

  #HTTP access from anywhere
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access
  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
