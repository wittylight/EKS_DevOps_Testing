region           = "us-west-2"
vpc_id           = "vpc-0384aa0e5691eb4d9"
#instance_type    = "m5.large"
private_subnets  = ["subnet-0bd880146f27adf68", "subnet-0327161a1cbb8604e","subnet-0373855f2cd253076"]
cluster_name     = "bcaa-ops-eks"
cluster_version  = "1.19"
#cidr_block       = "10.129.32.0/21"
keypair          = "bcaa-ops-eks-keypair"
kms_key_arn      = "arn:aws:kms:us-west-2:155754364360:key/9c5f65ba-822c-43f9-93ef-a70159168fe3"


map_roles = [
    {
      rolearn  = "arn:aws:iam::155754364360:role/AWSReservedSSO_Automation-EKSAdmin_84cae3767de816c5"    
      username = "adminuser:{{SessionName}}"
      groups   = ["system:masters"]
    }
  ]

map_users = [
    {
      userarn  = "arn:aws:iam::155754364360:user/bcaa-ops-admin"
      username = "opsadmin"
      groups   = ["system:masters"]
    }
  ]