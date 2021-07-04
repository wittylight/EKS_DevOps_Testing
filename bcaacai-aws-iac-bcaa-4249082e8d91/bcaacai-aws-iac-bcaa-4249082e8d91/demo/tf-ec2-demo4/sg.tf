###  Instance Security Group
resource "aws_security_group" "demo_instance" {
  name        = "demo4-instance-sg"
  description = "Security Group for DEMO instances"
  vpc_id      = var.vpc_id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_port_22_inbound" {
  type        = "ingress"
  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.demo_instance.id
}

resource "aws_security_group_rule" "instance_allow_port_80_inbound" {
  type        = "ingress"
  from_port   = "80"
  to_port     = "80"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.demo_instance.id
}

###  ELB Security Group
resource "aws_security_group" "demo_elb" {
  name        = "demo4-elb-sg"
  description = "Security Group for DEMO ELB"
  vpc_id      = var.vpc_id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "elb_allow_port_80_inbound" {
  type        = "ingress"
  from_port   = "80"
  to_port     = "80"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.demo_elb.id
}