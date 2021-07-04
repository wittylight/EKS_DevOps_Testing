resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "eks_worker_group_mgmt_one"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.cidr_block,
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "eks_all_worker_management"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
