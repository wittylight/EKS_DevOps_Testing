
locals {
  cluster_name                  = var.cluster_name
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler-chart"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.1.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.private_subnets
  vpc_id          = var.vpc_id
  enable_irsa     = true
  
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = {
    Environment = "EKS"
    Creator     = "Kevin Zhang"
    Team        = "Cloud and AI"
    Project     = "Automation"
  }

  fargate_profiles = {
    default = {
      name = "${var.cluster_name}-fargate-default"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
 #          computation-mode = "fargate"
          }
        },
        {
          namespace = "default"
          # Kubernetes labels for selection
          # labels = {
          #   Environment = "test"
          #   GithubRepo  = "terraform-aws-eks"
          #   GithubOrg   = "terraform-aws-modules"
          # }
        }
      ]

      tags = {
        Owner = "test"
      }
    }

  }

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }


  node_groups = {

    spot-4vcpu-16gb= {
      name             = "spot-node-group"
      desired_capacity = 3
      max_capacity     = 15
      min_capacity     = 1

      instance_types           = ["m5.large","m5a.xlarge","m5d.xlarge","m4.xlarge","m5n.xlarge","m5ad.xlarge","m5dn.xlarge"]
      capacity_type            = "SPOT"
      spot_allocation_strategy = "capacity-optimized"

      k8s_labels = {
        Environment = "NeatProd"
        lifecycle   = "Ec2Spot"
        intent      = "apps"
      }
      additional_tags = {
        "k8s.io/cluster-autoscaler/node-template/label/lifecycle" = "Ec2Spot"
        "k8s.io/cluster-autoscaler/node-template/label/intent" = "apps"
      }
      /*
      taints = [
        {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      ]
      */
    },


    on-demand= {
      name             = "on-demand-node-group"
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1
 
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        Environment = "NeatProd"
        lifecycle   = "OnDemand"
        intent      = "control-apps"
      }
      additional_tags = {
        CustomTag = "Neat EKS"
      }
    }
  }


  map_users    = var.map_users
  map_roles    = var.map_roles
  map_accounts = var.map_accounts
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}


module "eks_fargate" {
  source  = "terraform-module/eks-fargate-profile/aws"
  version = "2.2.0"

  cluster_name         = module.eks.cluster_id
  subnet_ids           = var.private_subnets
  namespaces           = ["csneat"]
  labels = {
    "app.kubernetes.io/name" = "csneat"
  }
  tags = {
    "ENV" = "csneat"
  }
}