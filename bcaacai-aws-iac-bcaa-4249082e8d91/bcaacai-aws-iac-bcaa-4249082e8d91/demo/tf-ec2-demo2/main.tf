provider "aws" {
  region = "us-west-2"
#  access_key = "ACCESS_KEY_HERE"
#  secret_key = "SECRET_KEY_HERE"
}


data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "tag:Purpose"
    values = ["BaseAMI"]
  }

  owners = ["self"]
}


resource "aws_instance" "demo" {
    ami                    = data.aws_ami.ami.id
    instance_type          = "t2.large"
    key_name               = "auto"
    vpc_security_group_ids = ["sg-00988e5300cdea559"]
    subnet_id              = "subnet-05244f0938156fe11"

    root_block_device {
      volume_type = "gp2"
      volume_size = 20
    }

    tags = {
     Name = "demo2"
    }

    connection {
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file("ssh/auto.pem")
      timeout     = "10m"
    }

    provisioner "file" {
        source      = "files/index.html"
        destination = "/tmp/index.html"
    }

    provisioner "remote-exec" {
    inline = [
      # sleep 60
      "sleep 60",

      # Run nginx demo site
      "sudo mkdir -p /home/ubuntu/nginx-html",
      "sudo mv /tmp/index.html /home/ubuntu/nginx-html",
      "docker run -d -v `pwd`/nginx-html:/usr/share/nginx/html --name mynginx -p 80:80 nginx",
    ]
  }

}

resource "aws_route53_record" "demo" {
   zone_id = "Z05738132YWDY4F269XFB"
   name    = "demo2.bcaa.cloud"
   type    = "A"
   ttl     = "60"
   records = [aws_instance.demo.public_ip]
}
