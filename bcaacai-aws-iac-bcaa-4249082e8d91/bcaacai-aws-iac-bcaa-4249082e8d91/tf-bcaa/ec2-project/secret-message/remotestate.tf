data "terraform_remote_state" "vpc" {
 backend   = "s3"
 workspace = "live"

 config {
   region               = "us-west-2"
   bucket               = "bcaa-automation-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/vpc/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}

data "terraform_remote_state" "security_group" {
 backend   = "s3"
 workspace = "live"

 config {
  region                = "us-east-1"
   bucket               = "chimp-util-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/security_group/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}
