module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.private_subnets

  tags = {
    Environment = "EKS"
  }

  vpc_id = var.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                 = "worker-group"
      instance_type        = var.instance_type
   #   ami_id               = data.aws_ami.ami.id
      additional_userdata  = "sudo sysctl -w vm.max_map_count=262144"
      asg_desired_capacity = 3
      asg_max_size         = 5
      asg_min_size         = 3
      root_volume_size     = "100"
      root_volume_type     = "gp2"
      root_iops            = "0"
      key_name             = var.keypair
      autoscaling_enabled  = true
      root_encrypted       = true

#      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  
  map_users    = var.map_users
  map_roles    = var.map_roles
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
