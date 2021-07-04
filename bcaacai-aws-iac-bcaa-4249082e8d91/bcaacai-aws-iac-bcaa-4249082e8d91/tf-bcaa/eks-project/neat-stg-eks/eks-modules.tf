module "cluster_autoscaler" {
  source = "git::git@bitbucket.org:bcaacai/terraform-aws-eks-cluster-autoscaler?ref=master"

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  k8s_namespace                    = "kube-system"
}

module "alb_ingress_controller" {
  source = "git::git@bitbucket.org:bcaacai/terraform-aws-eks-alb-ingress?ref=master"

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  k8s_namespace                    = "kube-system"
  vpc_id                           = var.vpc_id
}

module "extenral_dns" {
  source = "git::git@bitbucket.org:bcaacai/terraform-aws-eks-external-dns?ref=master"

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  k8s_namespace                    = "kube-system"

  settings = {
    ## sources:
    ## - service
    ## - ingress

    ## coredns:
    ##   etcdTLS:
    ##     enabled: false
    #"coredns.etcdTLS.enabled" = "false"    
    
    # domainFilters:
    "domainFilters[0]" = "bcaa.cloud"
  }
}

module "metrics_server" {
  source = "git::git@bitbucket.org:bcaacai/terraform-aws-eks-metrics-server?ref=master"
  k8s_namespace = "kube-system"
}

module "kubernetes_dashboard" {
  source = "git::git@bitbucket.org:bcaacai/terraform-aws-eks-kubernetes-dashboard?ref=master"
  k8s_namespace = "kube-system"
#  enabled = false

  settings = {
    "metrics-server.enabled" = "true"
    #"service.externalPort"   = "8080" 
    #"resources.limits.cpu"   = "200m"
  }
}

module "aws_node_termination_handler" {
  source = "git::git@bitbucket.org:bcaacai/terraform-aws-eks-aws-node-termination-handler?ref=master"
}
