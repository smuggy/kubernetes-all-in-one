data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "a" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-2a"
}

locals {
  vpc_id     = data.aws_vpc.default.id
  subnet_id  = data.aws_subnet.a.id
  user_name  = "ubuntu"
  public_ip  = aws_instance.node.public_ip
  private_ip = aws_instance.node.private_ip
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
