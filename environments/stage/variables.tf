#Terraform uses thos file to DEFINE variables. Use this file in conjuction with terraform.tvars

variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "amis"{
  type = "map"
#Commented the below block because assignment has been move to terraform.tfvars
  default = {
    "us-east-1" = "ami-0cc96feef8c6bbff3"
  }
}
