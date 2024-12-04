variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_types" {
  type = map(string)
  default = {
    "web"            = "t2.micro"
    "example"        = "t2.micro"
    "other_instance" = "t4g.micro"
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
