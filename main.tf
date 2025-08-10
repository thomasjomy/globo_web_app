provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}


data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
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
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.app
  map_public_ip_on_launch = true
  tags                    = local.common_tags
}


# Routing
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route = {
    cidr_block           = "0.0.0.0/0"
    aws_internet_gateway = aws_internet_gateway.app.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.app.vpc_id

}

## Security Groups
resource "aws_security_group" "ngnix_security_group" {
  name   = "ngnix_sg"
  vpc_id = aws_vpc.app.id

  #HTTP access from anywhere
  ingress = {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_block = "[0.0.0.0/0]"
  }

  #Outbound internet access
  egress = {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}


resource "aws_instance" "ngnix1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1
  vpc_security_group_ids = [aws_security_group.ngnix_security_group]
  tags                   = local.common_tags
}
