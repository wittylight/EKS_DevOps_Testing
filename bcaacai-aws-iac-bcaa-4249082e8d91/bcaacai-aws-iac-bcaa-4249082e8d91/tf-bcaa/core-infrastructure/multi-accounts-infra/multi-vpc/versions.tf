terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
  }

  backend "s3" {
    profile              = "automation_tf"
    region               = "us-west-2"
    bucket               = "bcaa-automation-terraform-state"
    key                  = "core/vpc/terraform.tfstate"
    dynamodb_table       = "bcaa-automation-terraform-state-lock"
    workspace_key_prefix = "multi-accounts"
    encrypt              = true     #AES-256 encryption
  }  
}
