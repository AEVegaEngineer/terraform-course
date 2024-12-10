data "terraform_remote_state" "first-steps" {
  backend = "s3"

  config = {
    bucket = "terraform-state-18726370"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  vpc_id = data.terraform_remote_state.first-steps.outputs.vpc_id
}

output "vpc_id" {
  value = local.vpc_id
}
