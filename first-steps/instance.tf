provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_types.web

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_web.id]
  key_name               = aws_key_pair.mykey.key_name

  user_data = templatefile("${path.module}/templates/web.tpl", {
    "region"     = var.aws_region
    "bucketname" = var.bucket_name
  })
  tags = {
    Name = "web"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "allow_ssh"
  }

  egress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "allow_web"
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# para crear llaves ssh ejecutar: ssh-keygen -f mykey
# hay otras flags que indican la encriptacion de la llave, fecha de expiracion, etc.

# luego, el comando para entrar con ssh a nuestra instancia es:
# ssh -i ~/.ssh/mykey -l ubuntu <ip_publica>
# ctrl+d para salir
resource "aws_key_pair" "mykey" {
  key_name = "my-key-pair"

  # public_key = file("~/.ssh/id_rsa.pub")
  public_key = file("~/.ssh/mykey.pub")
}
