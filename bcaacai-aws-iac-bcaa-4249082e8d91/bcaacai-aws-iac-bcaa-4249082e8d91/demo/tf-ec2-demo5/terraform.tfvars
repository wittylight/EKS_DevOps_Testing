vpc_id             = "vpc-0384aa0e5691eb4d9"
instance_type      = "t2.micro"
zone_id            = "Z05738132YWDY4F269XFB"
subnet_ids         = ["subnet-05244f0938156fe11", "subnet-05bc1f2a24b5053d8","subnet-067cb9a00dc2ff951"]
stickiness_enabled = false
min_size           = 2
max_size           = 6
desired_capacity   = 2

cpu_utilization_high_evaluation_periods = 1
cpu_utilization_high_period_second      = 300
cpu_utilization_low_evaluation_periods  = 1
cpu_utilization_low_period_seconds      = 300 
