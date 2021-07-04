resource "aws_elb" "elb" {
  name            = "demo5-elb"
  subnets         = var.subnet_ids
  internal        = false
  security_groups = [aws_security_group.demo_elb.id]

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  listener {
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }
  

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}


resource "aws_lb_cookie_stickiness_policy" "elb" {
  count                    = var.stickiness_enabled ? 1 : 0
  name                     = "demo4-elb-policy"
  load_balancer            = aws_elb.elb.name
  lb_port                  = 80
  cookie_expiration_period = 600
}
