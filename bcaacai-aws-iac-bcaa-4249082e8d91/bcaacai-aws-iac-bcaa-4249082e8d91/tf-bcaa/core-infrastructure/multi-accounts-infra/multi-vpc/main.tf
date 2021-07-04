provider "aws" {

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  profile = local.workspace["profile"]
  region  = local.workspace["region"]
  shared_credentials_file = "~/.aws/credentials"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name = var.name
  cidr = var.cidr

  azs                 = var.azs
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  #create_egress_only_igw = false

  public_subnet_suffix   = "pub"
  private_subnet_suffix  = "pri"


  enable_ipv6                                    = false
  private_subnet_assign_ipv6_address_on_creation = false
  private_subnet_ipv6_prefixes                   = [0, 1, 2]

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  #enable_classiclink             = true
  #enable_classiclink_dns_support = true

  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "us-west-2.compute.internal"
  dhcp_options_domain_name_servers = var.dhcp_options_domain_name_servers

  enable_flow_log           = true
  flow_log_destination_type = "s3"
  flow_log_destination_arn  = var.flow_log_destination_arn

  vpc_flow_log_tags = {
    Name = "vpc-flow-logs-s3-bucket"
  }

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC endpoint for DynamoDB
  enable_dynamodb_endpoint = true

  # VPC endpoint for SSM
  enable_ssm_endpoint              = true
  ssm_endpoint_private_dns_enabled = true
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for SSMMESSAGES
  enable_ssmmessages_endpoint              = false
  ssmmessages_endpoint_private_dns_enabled = false
  ssmmessages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for EC2
  enable_ec2_endpoint              = false
  ec2_endpoint_private_dns_enabled = false
  ec2_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for EC2MESSAGES
  enable_ec2messages_endpoint              = false
  ec2messages_endpoint_private_dns_enabled = false
  ec2messages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR API
  enable_ecr_api_endpoint              = false
  ecr_api_endpoint_private_dns_enabled = false
  ecr_api_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR DKR
  enable_ecr_dkr_endpoint              = true
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for KMS
  enable_kms_endpoint              = true
  kms_endpoint_private_dns_enabled = true
  kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for ECS
  enable_ecs_endpoint              = false
  ecs_endpoint_private_dns_enabled = false
  ecs_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for ECS telemetry
  enable_ecs_telemetry_endpoint              = false
  ecs_telemetry_endpoint_private_dns_enabled = false
  ecs_telemetry_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for SQS
  enable_sqs_endpoint              = true
  sqs_endpoint_private_dns_enabled = true
  sqs_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  tags = {
      "Creator"     = "Kevin Zhang"
      "Department"  = "Cloud Engineering and AI"
      "Project"     = "IaC"
      "Environment" = local.workspace["profile"]
      "Description" = "VPC infrastructure of ${local.workspace["profile"]} account"
      "Owner"       = "Kevin Zhang"
      "Managed by"  = "Terraform"
   # Name        = "${local.workspace["profile"]}_vpc1"
   # "kubernetes.io/cluster/EVO-DEV-EKS" = "shared"
   # "kubernetes.io/role/internal-elb"   = "1"   
  }

  vpc_endpoint_tags = {
    Project  = "Secret"
    Endpoint = "true"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }

}


resource "aws_ec2_transit_gateway_vpc_attachment" "example" {
  subnet_ids         = module.vpc.private_subnets
  transit_gateway_id = var.tgw_id
  vpc_id             = module.vpc.vpc_id

  tags = {
    Name = "${var.name}_twg_attchment"
    Side = "Creator"
  }
}

/*
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "example" {
  provider = aws.share

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.example.id

  tags = {
    Name = "${var.name}_twg_attchment"
    Side = "Accepter"
  }
}
*/
