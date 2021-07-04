region           = "ca-central-1"
vpc_id           = "vpc-06fd94a753c35d8c9"
instance_type    = "t2.small"
private_subnets  = ["subnet-0c4bcfd518434af26", "subnet-0f797a33cd78adfd3","subnet-0a4e3980f8ec08081"]
cluster_name     = "qp-dev-eks"
cluster_version  = "1.18"
cidr_block       = "10.129.16.0/21"
keypair          = "DNA_PreProd_Central_EKS"

map_roles = [
    {
      rolearn  = "arn:aws:iam::632856304542:role/AWSReservedSSO_DnAPreProd-EKSAdmin_f7a04b608f378f78"
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