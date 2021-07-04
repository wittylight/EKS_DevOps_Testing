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

variable "instance_type" {
  # Smallest recommended, where ~1.1Gb of 2Gb memory is available for the Kubernetes pods after ‘warming up’ Docker, Kubelet, and OS
  default = "t3.small"
  type    = string
}

variable "kms_key_arn" {
  default     = ""
  description = "KMS key ARN to use if you want to encrypt EKS node root volumes"
  type        = string
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
      rolearn  = "arn:aws:iam::155754364360:role/AWSReservedSSO_Automation-EKSAdmin_84cae3767de816c5"
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
      userarn  = "arn:aws:iam::155754364360:user/bcaa-ops-admin"
      username = "opsadmin"
      groups   = ["system:masters"]
    }
  ]
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "155754364360",
    "888888888888",
  ]
}

variable "addon_kube_proxy_version" {
   type    = string
   default = "v1.19.6-eksbuild.2"
}

variable "addon_vpc_cni_version" {
   type    = string
   default = "v1.7.5-eksbuild.2"
}

variable "addon_coredns_version" {
   type    = string
   default = "v1.8.0-eksbuild.1"
}

