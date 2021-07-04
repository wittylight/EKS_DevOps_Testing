region           = "us-west-2"
vpc_id           = "vpc-09b23ec2a09ad11b1"
instance_type    = "m5.large"
private_subnets  = ["subnet-01529b2009ec54d8d", "subnet-0a9b64c95a8db8924","subnet-0a865322181b596f5"]
cluster_name     = "neat-qa-eks"
cluster_version  = "1.19"
#cidr_block       = "10.129.32.0/21"
keypair          = "neat-qa-eks-keypair"

map_roles = [
    {
      rolearn  = "arn:aws:iam::675097064651:role/AWSReservedSSO_MSQA-EKSAdmin_ff8f1ac5ca9efe10"      
      username = "adminuser:{{SessionName}}"
      groups   = ["system:masters"]
    }
  ]

map_users = [
    {
      userarn  = "arn:aws:iam::675097064651:user/opsadmin"
      username = "opsadmin"
      groups   = ["system:masters"]
    }
  ]