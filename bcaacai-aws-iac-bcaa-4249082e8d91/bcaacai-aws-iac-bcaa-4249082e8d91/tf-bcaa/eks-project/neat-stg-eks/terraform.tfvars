region           = "us-west-2"
vpc_id           = "vpc-07687ea2cf5323cfb"
instance_type    = "m5.large"
private_subnets  = ["subnet-05b4033064c4b03f6", "subnet-0bfa9ae5351c59649","subnet-091c96340902073cf","subnet-0965ef572bd1983d0"]
cluster_name     = "neat-stg-eks"
cluster_version  = "1.19"
#cidr_block       = "10.129.32.0/21"
keypair          = "neat-stg-eks-keypair"

map_roles = [
    {
      rolearn  = "arn:aws:iam::813123654187:role/AWSReservedSSO_NeatPreProd-EKSAdmin_7845cbf7963924b9"      
      username = "adminuser:{{SessionName}}"
      groups   = ["system:masters"]
    }
  ]

map_users = [
    {
      userarn  = "arn:aws:iam::813123654187:user/opsadmin"
      username = "opsadmin"
      groups   = ["system:masters"]
    }
  ]