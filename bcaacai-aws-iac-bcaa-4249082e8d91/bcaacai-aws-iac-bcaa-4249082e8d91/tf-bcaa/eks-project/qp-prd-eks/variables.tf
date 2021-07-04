variable "region" {
  type    = string
  description = "AWS region"
}

variable "vpc_id" {
  type    = string
}

variable "cluster_name" {
  type    = string
}

variable "private_subnets" {
  type    = list(string)
}

variable "instance_type" {
  type    = string
}

variable "keypair" {
  type    = string
}

variable "cluster_version" {
  type    = string
}

variable "cidr_block" {
  default = "0.0.0.0/0"
  type    = string
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::632856304542:role/AWSReservedSSO_DnAPreProd-EKSAdmin_f7a04b608f378f78"
      username = "adminuser:{{SessionName}}"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::155754364360:user/eksadmin"
      username = "eksadmin"
      groups   = ["system:masters"]
    }
  ]
}
