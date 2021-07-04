resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "kube-proxy"
  addon_version     = var.addon_kube_proxy_version
  resolve_conflicts = "OVERWRITE"  
  tags = {
      "eks_addon" = "kube-proxy"
    }  
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "vpc-cni"
  addon_version     = var.addon_vpc_cni_version
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "vpc-cni"
    }    
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = module.eks.cluster_id
  addon_name        = "coredns"
  addon_version     = var.addon_coredns_version
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "coredns"
    }      
}