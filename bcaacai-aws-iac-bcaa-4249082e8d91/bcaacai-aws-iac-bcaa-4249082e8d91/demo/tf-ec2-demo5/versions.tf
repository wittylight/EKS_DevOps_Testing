terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
  }
  
  backend "s3" {
    profile              = "automation"
    region               = "us-west-2"
    bucket               = "bcaa-automation-terraform-state"
    dynamodb_table       = "bcaa-automation-terraform-state-lock"
    key                  = "single-account/automation/demo/tf-ec2-demo5/terraform.tfstate"
    encrypt              = true     #AES-256 encryption
  }  
}
