terraform {
  required_version = ">= 0.11.3"
  backend "s3" {
    profile       ="live"
    region         = "us-east-1"
    bucket         = "chimp-util-terraform-state"
    dynamodb_table = "chimp-util-terraform-state-lock"
    key            = "base/ec2-projects/secret-message/terraform.tfstate"
    encrypt        = true    #AES-256 encryption
  }
}
