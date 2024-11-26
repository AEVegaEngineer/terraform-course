provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_types.example
  tags = {
    Name = "example"
  }
}

