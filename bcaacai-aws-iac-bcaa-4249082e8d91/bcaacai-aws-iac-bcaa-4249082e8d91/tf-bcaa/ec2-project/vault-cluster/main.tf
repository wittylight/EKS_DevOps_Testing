provider "aws" {

  region = "us-west-2"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

data "aws_caller_identity" "default" {}

data "aws_region" "default" {}

module "vault_cluster_label" {
  source     = "git::git@bitbucket.org:bcaacai/terraform-null-label?ref=master"
  attributes = compact(concat(var.attributes, ["server","cluster"]))
  delimiter  = var.delimiter
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    consul_cluster_tag_key   = "cluster_tag_key"
    consul_cluster_tag_value = var.cluster_tag_value
    s3_bucket_name           = module.vault_storage.bucket_id
    aws_region               = data.aws_region.default.name
    kms_key_id               = module.kms_key.key_id
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name = "tag:service"
    values = ["vault-consul"]
  }

  filter {
    name = "tag:system"
    values = ["bionic-18.04"]
  }
}

resource "aws_iam_instance_profile" "default_vault" {
  name  = "${module.vault_cluster_label.id}-instance-profile"
  path  = "/"
  role  = aws_iam_role.default_vault_role.name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "default_vault_role" {
  name = "${module.vault_cluster_label.id}-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "vault_s3_policy" {
  name   = "${module.vault_cluster_label.id}-s3-policy"
  role   = aws_iam_role.default_vault_role.id
  policy = data.aws_iam_policy_document.vault_s3.json
}

data "aws_iam_policy_document" "vault_s3" {
  statement {
    sid = ""

    effect = "Allow"

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${module.vault_storage.bucket_id}",
      "arn:aws:s3:::${module.vault_storage.bucket_id}/*",
    ]
  }
}

resource "aws_iam_role_policy" "vault_auto_unseal_kms_policy" {
  name = "${module.vault_cluster_label.id}-kms-policy"
  role = aws_iam_role.default_vault_role.id
  policy = data.aws_iam_policy_document.vault_auto_unseal_kms.json
}

data "aws_iam_policy_document" "vault_auto_unseal_kms" {
  statement {
    effect = "Allow"

    actions = ["kms:*"]

    resources = [module.kms_key.key_arn]
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core_role_policy_attach" {
  role       = aws_iam_role.default_vault_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "consul_policy" {
  name = "${module.vault_cluster_label.id}-consul-policy"
  role = aws_iam_role.default_vault_role.id
  policy = data.aws_iam_policy_document.consul.json
}

data "aws_iam_policy_document" "consul" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "autoscaling:DescribeAutoScalingGroups",
    ]
    resources = ["*"]
  }
}

module "kms_key" {
  source                  = "git::git@bitbucket.org:bcaacai/terraform-aws-kms-key?ref=master"
  name                    = var.name
  namespace               = var.namespace
  stage                   = var.stage
  attributes              = compact(concat(var.attributes, ["cluster"]))
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

module "vault_storage" {
  source                   = "git::git@bitbucket.org:bcaacai/terraform-aws-s3-log-storage?ref=master"
  name                     = var.name
  namespace                = var.namespace
  stage                    = var.stage
  delimiter                = var.delimiter
  attributes               = compact(concat(var.attributes, ["storage"]))

  region                   = data.aws_region.default.name
  lifecycle_prefix         = var.prefix
  acl                      = var.acl
  policy                   = var.policy
  force_destroy            = var.force_destroy
  versioning_enabled       = var.versioning_enabled
  lifecycle_rule_enabled   = var.lifecycle_rule_enabled
  standard_transition_days = var.standard_transition_days
  glacier_transition_days  = var.glacier_transition_days
  expiration_days          = var.expiration_days
  sse_algorithm            = var.sse_algorithm
  kms_master_key_arn       = module.kms_key.key_arn

  block_public_acls        = var.block_public_acls
  block_public_policy      = var.block_public_policy
  ignore_public_acls       = var.ignore_public_acls
  restrict_public_buckets  = var.restrict_public_buckets
}

module "autoscale_group" {
  source                   = "git::git@bitbucket.org:bcaacai/terraform-aws-ec2-autoscale-group?ref=master"
  name                     = var.name
  namespace                = var.namespace
  stage                    = var.stage
  delimiter                = var.delimiter
  attributes               = compact(concat(var.attributes, ["cluster"]))

  image_id                    = data.aws_ami.ami.id
  iam_instance_profile_name   = aws_iam_instance_profile.default_vault.name
  instance_type               = var.instance_type
  key_name                    = var.key_name
  termination_policies        = ["Default"]
  security_group_ids          = [aws_security_group.default.id]
  subnet_ids                  = data.terraform_remote_state.vpc.outputs.private_subnets
  health_check_type           = "EC2"
  min_size                    = 2
  max_size                    = 3
  #desired_capacity            = 2
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = false
  user_data_base64            = base64encode(data.template_file.user_data.rendered)

  tags = {
    vault-cluster          = "${module.vault_cluster_label.id}"
    Creator                = "Kevin Zhang"
    consul_cluster_tag_key = "cluster_tag_key"
  }

  autoscaling_policies_enabled              = true
  cpu_utilization_high_threshold_percent    = 80
  cpu_utilization_low_threshold_percent     = 20
}


module "vault_elb" {
  source                      = "git::git@bitbucket.org:bcaacai/terraform-aws-elb?ref=master" 
  name                        = var.name
  namespace                   = var.namespace
  stage                       = var.stage

  internal                    = var.elb_internal
  subnets                     = data.terraform_remote_state.vpc.outputs.private_subnets
  security_groups             = [aws_security_group.elb_default.id]

  cross_zone_load_balancing   = var.elb_cross_zone_load_balancing
  idle_timeout                = var.elb_idle_timeout
  connection_draining         = var.elb_connection_draining
  connection_draining_timeout = var.elb_connection_draining_timeout

  listener =[
   {
      instance_port      = var.vault_api_port
      instance_protocol  = "HTTP"
      lb_port            = var.lb_port
      lb_protocol        = "HTTPS"
      ssl_certificate_id = "arn:aws:acm:us-west-2:155754364360:certificate/c7169aef-85c9-44b6-a6ba-9ce8a05987af"
   }
  ]

  health_check = {
    target              = "HTTP:${var.vault_api_port}${var.health_check_path}"
    interval            = var.health_check_interval
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
  }
  
}

resource "aws_autoscaling_attachment" "vault" {
  autoscaling_group_name = module.autoscale_group.autoscaling_group_id
  elb                    = module.vault_elb.elb_id
}

module "vault_dns" {
  source          = "git::git@bitbucket.org:bcaacai/terraform-aws-route53-alias?ref=master"
  aliases         = ["vault.bcaa.cloud"]
  parent_zone_id  = "Z05738132YWDY4F269XFB"
  target_dns_name = module.vault_elb.elb_dns_name
  target_zone_id  = module.vault_elb.elb_zone_id
}