provider "aws" {
  region  = "us-west-2"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

 module "terraform_state_backend" {
   source = "cloudposse/tfstate-backend/aws"
   version     = "0.32.1"
   namespace  = "bcaa"
   stage      = "automation"
   name       = "terraform"
   attributes = ["state"]

   force_destroy = false

   s3_replication_enabled = false
   s3_replica_bucket_arn  = "arn:aws:s3:::bcaa-automation-terraform-tfstate-replica"
 }