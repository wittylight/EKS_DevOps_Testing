region           = "ca-central-1"
vpc_id           = "vpc-0d9f7f03f300a5356"
instance_type    = "t2.large"
private_subnets  = ["subnet-0f49c77f424672293", "subnet-0a04a7cd2734472e5","subnet-077bc652428d46dd8"]
cluster_name     = "qp-prd-eks"
cluster_version  = "1.18"
cidr_block       = "10.129.32.0/21"
keypair          = "DNA_Prod_Central_EKS"

map_roles = [
    {
      rolearn  = "arn:aws:iam::607968612228:role/AWSReservedSSO_DnAProd-EKSAdmin_9db5d490cb8689c0"
      username = "adminuser:{{SessionName}}"
      groups   = ["system:masters"]
    }
  ]

map_users = [
    {
      userarn  = "arn:aws:iam::155754364360:user/eksadmin"
      username = "eksadmin"
      groups   = ["system:masters"]
    }
  ]