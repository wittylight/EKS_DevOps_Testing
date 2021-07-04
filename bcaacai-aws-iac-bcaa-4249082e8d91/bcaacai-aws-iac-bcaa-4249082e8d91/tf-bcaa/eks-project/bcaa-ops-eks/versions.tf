terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }

  required_version = ">= 0.14"

  backend "s3" {
    profile              = "automation_tf"
    region               = "us-west-2"
    bucket               = "bcaa-automation-terraform-state"
    dynamodb_table       = "bcaa-automation-terraform-state-lock"
    key                  = "single-account/automation/eks-projects/bcaa-ops-eks/terraform.tfstate"
    encrypt              = true     #AES-256 encryption
  }  
  
}

