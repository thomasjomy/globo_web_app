data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_instance" "ngnix1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux)
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg]
  tags                   = local.common_tags
}

