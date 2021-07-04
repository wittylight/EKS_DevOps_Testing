data "terraform_remote_state" "vpc" {
 backend   = "s3"
 workspace = "automation"

 config = {
   profile              = "automation"
   region               = "us-west-2"
   bucket               = "bcaa-automation-terraform-state"
   workspace_key_prefix = "multi-accounts"
   key                  = "core/vpc/terraform.tfstate"
   encrypt              = true    #AES-256 encryption
 }
}