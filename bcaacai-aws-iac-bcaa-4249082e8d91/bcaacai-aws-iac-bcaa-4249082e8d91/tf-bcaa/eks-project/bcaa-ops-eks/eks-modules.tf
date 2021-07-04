module "cluster_autoscaler" {
  source = "./modules/terraform-aws-eks-cluster-autoscaler/"

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  k8s_namespace                    = "kube-system"
}

module "alb_ingress_controller" {
  source = "./modules/terraform-aws-eks-alb-ingress/"

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  k8s_namespace                    = "kube-system"
  vpc_id                           = var.vpc_id
}

module "extenral_dns" {
  source = "./modules/terraform-aws-eks-external-dns/"

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
    "coredns.etcdTLS.enabled" = "false"    
    
    # domainFilters:
    "domainFilters[0]" = "bcaa.cloud"
  }
}

module "metrics_server" {
  source = "./modules/terraform-aws-eks-metrics-server/"

 # cluster_name                     = module.eks.cluster_id
 # cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
 # cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  k8s_namespace                    = "kube-system"
}

module "kubernetes_dashboard" {
  source = "./modules/terraform-aws-eks-kubernetes-dashboard/"
  k8s_namespace                    = "kube-system"

  settings = {
    "metrics-server.enabled" = "true"
    #"service.externalPort"   = "8080" 
    #"resources.limits.cpu"   = "200m"
  }
}


module "aws_node_termination_handler" {
  source  = "./modules/terraform-aws-eks-aws-node-termination-handler/"
}
