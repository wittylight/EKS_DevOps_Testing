locals {
  cluster_name                  = var.cluster_name
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler-chart"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.0.3"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.private_subnets
  vpc_id          = var.vpc_id
  enable_irsa     = false

  tags = {
    Environment = "EKS"
    Creator     = "Kevin Zhang"
    Team        = "Cloud and AI"
    Project     = "Automation"
  }

/*
  workers_group_defaults = {
    root_volume_type = "gp3"
  }

  worker_groups = [
    {
      name                 = "worker-group"
      instance_type        = var.instance_type
 #     ami_id               = data.aws_ami.ami.id
      additional_userdata  = "sudo sysctl -w vm.max_map_count=262144"
      asg_desired_capacity = 2
      asg_max_size         = 10
      asg_min_size         = 2
      root_volume_size     = "200"
      root_volume_type     = "gp3"
      root_iops            = "0"
      key_name             = var.keypair
      autoscaling_enabled  = true
      root_encrypted       = true

      tags = [
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${local.cluster_name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]

#      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]

*/


  fargate_profiles = {
    default = {
      name = "${var.cluster_name}-default"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
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

      # using specific subnets instead of all the ones configured in eks
      # subnets = ["subnet-0ca3e3d1234a56c78"]

      tags = {
        Owner = "test"
      }
    }
  }

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }


#  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]

  node_groups = {
    spot-4vcpu-16gb= {
      name             = "spot-node-group"
      desired_capacity = 3
      max_capacity     = 15
      min_capacity     = 2

      instance_types = ["m5.large","m5a.xlarge","m5d.xlarge","m4.xlarge","m5n.xlarge","m5ad.xlarge","m5dn.xlarge"]
      capacity_type  = "SPOT"
      k8s_labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      additional_tags = {
        ExtraTag = "example"
      }
      taints = [
        {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      ]
    },

    on-demand= {
      name             = "on-demand-node-group"
      desired_capacity = 2
      max_capacity     = 15
      min_capacity     = 1
 
      #instance_type = var.instance_type      
 #     launch_template_id      = aws_launch_template.default.id
 #     launch_template_version = aws_launch_template.default.default_version
      capacity_type  = "ON_DEMAND"
      additional_tags = {
        CustomTag = "OPS EKS"
      }
    }
  }

  map_users    = var.map_users
  map_roles    = var.map_roles

}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
