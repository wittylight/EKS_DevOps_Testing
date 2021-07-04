# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP RULES THAT CONTROL WHAT TRAFFIC CAN GO IN AND OUT OF A VAULT CLUSTER
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "default" {
  name        = "${module.vault_cluster_label.id}-sg"
  description = "Security Group for Vault Cluster nodes"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags        = module.vault_cluster_label.tags

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_server_ssh_inbound" {
  type        = "ingress"
  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_api_inbound_from_cidr_blocks" {
  type        = "ingress"
  from_port   = var.api_port
  to_port     = var.api_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_cluster_inbound_from_self" {
  type        = "ingress"
  from_port   = var.cluster_port
  to_port     = var.cluster_port
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}


resource "aws_security_group" "elb_default" {
  name        = "${module.vault_cluster_label.id}-elb-sg"
  description = "Security Group for the ELB of Vault Cluster"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  tags        = module.vault_cluster_label.tags

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_server_https_inbound" {
  type        = "ingress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb_default.id
}