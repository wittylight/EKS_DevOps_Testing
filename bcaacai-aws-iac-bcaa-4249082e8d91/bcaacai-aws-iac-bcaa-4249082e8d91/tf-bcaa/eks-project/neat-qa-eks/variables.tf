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
      rolearn  = "arn:aws:iam::675097064651:role/AWSReservedSSO_MSQA-EKSAdmin_ff8f1ac5ca9efe10"
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
      userarn  = "arn:aws:iam::675097064651:user/opsadmin"
      username = "opsadmin"
      groups   = ["system:masters"]
    }
  ]
}
