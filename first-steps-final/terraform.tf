terraform {
  backend "s3" {
    bucket = "terraform-state-18726370"
    key    = "terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locking"
    encrypt        = true
  }
}
provider "aws" {
  region = "us-east-1"
}
