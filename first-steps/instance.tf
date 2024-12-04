provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_types.web

  subnet_id = module.vpc.public_subnets[0]
  tags = {
    Name = "web"
  }
}

