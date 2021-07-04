provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "xenial" {
  most_recent = true
  filter {
    name = "tag:purpose"
    values = ["secret"]
  }
   owners = ["self"]
}

data "template_file" "user_data" {
  template = "${file("files/user-data.yml")}"
  vars {
    site = "${var.name}.chimpcloud.net"
  }
}

resource "aws_instance" "secret" {
    ami = "${data.aws_ami.xenial.id}"
    instance_type = "t2.small"
    key_name = "chimp-dev-base"
    monitoring = true
    vpc_security_group_ids = ["${data.terraform_remote_state.security_group.internal_vpc1_sg_security_group_id}"]

    subnet_id = "${element(data.terraform_remote_state.vpc.private_subnets, 0)}"
    root_block_device {
      volume_type = "gp2"
      volume_size = 30
    }

    user_data     = "${data.template_file.user_data.rendered}"

    tags = {
     Name = "secret_msg"
   }
}


//
// ELB
//
module "elb" {
  source = "../../../tf-modules/tf-aws-elb"

  name = "${var.name}-elb"
  subnets         = ["${compact(data.terraform_remote_state.vpc.public_subnets)}"]
  security_groups = ["${data.terraform_remote_state.security_group.http_ssl_only_sg_security_group_id}"]
  number_of_instances = 1
  instances       = ["${aws_instance.secret.id}"]

  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "443"
      lb_protocol       = "HTTPS"
      ssl_certificate_id = "${var.cert_arn}"
    }
  ]

  health_check = [
    {
      target              = "TCP:80"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 3
      timeout             = 5
    },
  ]

}

//
// Route53
//
data "aws_route53_zone" "public" {
  name         = "${var.dns_zone_name}"
  private_zone = false
}
data "aws_route53_zone" "private" {
  name         = "${var.dns_zone_name}"
  private_zone = true
}

// Public DNS
module "public-dns" {
  #source          = "git@github.com:ChimpTech/aws-automation.git?ref=master//tf-modules/tf-aws-route53-alias"
  source = "../../../tf-modules/tf-aws-route53-alias"
  aliases         = ["${var.name}.${var.dns_zone_name}"]
  parent_zone_id  = "${data.aws_route53_zone.public.zone_id}"
  target_dns_name = "${module.elb.this_elb_dns_name}"
  target_zone_id  = "${module.elb.this_elb_zone_id}"
}

// Private DNS
module "private-dns" {
  #source          = "git@github.com:ChimpTech/aws-automation.git?ref=master//tf-modules/tf-aws-route53-alias"
  source = "../../../tf-modules/tf-aws-route53-alias"
  aliases         = ["${var.name}.${var.dns_zone_name}"]
  parent_zone_id  = "${data.aws_route53_zone.private.zone_id}"
  target_dns_name = "${module.elb.this_elb_dns_name}"
  target_zone_id  = "${module.elb.this_elb_zone_id}"
}
