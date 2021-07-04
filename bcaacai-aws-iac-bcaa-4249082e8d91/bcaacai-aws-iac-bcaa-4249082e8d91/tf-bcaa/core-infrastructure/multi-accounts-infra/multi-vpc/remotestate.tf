/*
data "terraform_remote_state" "vpc" {
 backend   = "s3"
 workspace = terraform.workspace

 config = {
   profile              = "master"
   region               = "us-west-2"
   bucket               = "bcaa-iac-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/vpc/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}

data "terraform_remote_state" "route53_zone_cluster" {
 backend   = "s3"
 workspace = terraform.workspace

 config = {
   profile              = "master"
   region               = "us-west-2"
   bucket               = "bcaa-iac-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/route53-zone-cluster/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}

data "terraform_remote_state" "kms_key" {
 backend   = "s3"
 workspace = terraform.workspace

 config = {
   profile              = "master"
   region               = "us-west-2"
   bucket               = "bcaa-iac-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/kms-key/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}

data "terraform_remote_state" "key_pair" {
 backend   = "s3"
 workspace = terraform.workspace

 config = {
   profile              = "master"
   region               = "us-west-2"
   bucket               = "bcaa-iac-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/key-pair/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}

data "terraform_remote_state" "ssm_parameter_store" {
 backend   = "s3"
 workspace = terraform.workspace

 config = {
   profile              = "master"
   region               = "us-west-2"
   bucket               = "bcaa-iac-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/ssm-parameter-store/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}

data "terraform_remote_state" "security_group" {
 backend   = "s3"
 workspace = terraform.workspace

 config = {
   profile              = "master"
   region               = "us-west-2"
   bucket               = "bcaa-iac-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/security-group/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}

data "terraform_remote_state" "s3_bucket" {
 backend   = "s3"
 workspace = terraform.workspace

 config = {
   profile              = "master"
   region               = "us-west-2"
   bucket               = "bcaa-iac-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/s3/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}
*/