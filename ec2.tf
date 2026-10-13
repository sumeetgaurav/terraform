#Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "terra-key-ai-powered"
  public_key = file("terra-key.pub")
}

#VPC

resource "aws_default_vpc" "default" {}

#Security Group

resource "aws_security_group" "my_security_group" {

  name        = "terra-auto-sg-1"
  vpc_id      = aws_default_vpc.default.id #Interpolation
  description = "This is a Security Group that Opens SSH & Port 80"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all the protocols
}

#Instance Config - Instance Type,Storage,AMI,Instance Name

resource "aws_instance" "my_instance" {
  count                  = 3
  key_name               = aws_key_pair.my_key_pair.key_name #Interpolation for Key
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  ami                    = "ami-02167eae61967e403" # Needs to be Changed per region
  instance_type          = "t3.micro"
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
  tags = {
    Name = "terra-auto-server"
  }
}
