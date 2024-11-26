variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_types" {
  type = map(string)
  default = {
    "example" = "t2.micro"
  }
}
