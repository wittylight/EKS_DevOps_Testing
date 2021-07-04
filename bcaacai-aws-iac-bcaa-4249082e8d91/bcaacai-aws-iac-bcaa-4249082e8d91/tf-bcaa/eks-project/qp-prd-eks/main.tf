provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}
/*
data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "tag:Purpose"
    values = ["EKS_BaseAMI"]
  }

  owners = ["self"]
}
*/