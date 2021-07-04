region           = "us-west-2"
vpc_id           = "vpc-03001bd6fb2dcd654"
instance_type    = "m5.large"
private_subnets  = ["subnet-038ea71a0bc68683a", "subnet-0a67aae5d01efedd1","subnet-03ccabc7b5792e144","subnet-0c485ba318fea4408"]
cluster_name     = "neat-prd-eks"
cluster_version  = "1.19"
#cidr_block       = "10.129.32.0/21"
keypair          = "neat-prd-eks-keypair"

map_roles = [
    {
      rolearn  = "arn:aws:iam::363397377802:role/AWSReservedSSO_NeatProd-EKSAdmin_8a88fc853a5f4b45"      
      username = "adminuser:{{SessionName}}"
      groups   = ["system:masters"]
    }
  ]

map_users = [
    {
      userarn  = "arn:aws:iam::363397377802:user/opsadmin"
      username = "opsadmin"
      groups   = ["system:masters"]
    }
  ]