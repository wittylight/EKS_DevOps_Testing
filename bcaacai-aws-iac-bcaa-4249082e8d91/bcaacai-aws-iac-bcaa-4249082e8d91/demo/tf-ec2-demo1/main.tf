provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "demo" {
    ami                    = "ami-025102f49d03bec05"
    instance_type          = "t2.small"
    key_name               = "auto"
    vpc_security_group_ids = ["sg-00988e5300cdea559"]
    subnet_id              = "subnet-05244f0938156fe11"

    root_block_device {
      volume_type = "gp2"
      volume_size = 20
    }

    tags = {
     Name = "demo1"
    }
}
