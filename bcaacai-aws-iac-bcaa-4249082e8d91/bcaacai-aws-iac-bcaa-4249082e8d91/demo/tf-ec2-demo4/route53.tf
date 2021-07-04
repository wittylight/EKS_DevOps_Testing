### Route 53 
resource "aws_route53_record" "demo" {
   zone_id = var.zone_id
   name    = "demo.bcaa.cloud"
   type    = "A"
   
   alias {
     name                   = aws_elb.elb.dns_name
     zone_id                = aws_elb.elb.zone_id
     evaluate_target_health = true
   }
}

