provider "aws" {
  region = var.region
}

### Base AMI
data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "tag:Purpose"
    values = ["BaseAMI"]
  }

  owners = ["self"]
}


resource "aws_instance" "demo" {
    count                  = 3
    ami                    = data.aws_ami.ami.id
    instance_type          = var.instance_type
    iam_instance_profile   = aws_iam_instance_profile.demo.name
    key_name               = "auto"
    vpc_security_group_ids = [aws_security_group.demo_instance.id]
    subnet_id              = element(var.subnet_ids, count.index)

    root_block_device {
      volume_type = "gp2"
      volume_size = 20
    }

    tags = {
     Name = "demo3-server-${count.index+1}"
    }

/*
    connection {
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file("ssh/auto.pem")
      timeout     = "10m"
    }

    provisioner "remote-exec" {
    inline = [
      # sleep 30
      "sleep 30",

      # Run nginx demo site
      "sudo aws s3 cp s3://bcaa-demo-s3bucket/index.html /tmp/index.html",
      "sudo sed -i 's|##INDEX|${count.index+1}|g' /tmp/index.html",
      "sudo sed -i 's|##IP|${self.private_ip}|g' /tmp/index.html",
      "sudo mkdir -p /home/ubuntu/nginx-html",
      "sudo mv /tmp/index.html /home/ubuntu/nginx-html",
      "docker run -d -v `pwd`/nginx-html:/usr/share/nginx/html --name mynginx -p 80:80 nginx",
    ]
  }
*/
}

resource "null_resource" "demo" {
  count = 3

  connection {
    user        = "ubuntu"
    host        = element(aws_instance.demo.*.public_ip, count.index)
    private_key = file("ssh/auto.pem")
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      # sleep 30
      "sleep 30",

      # Run nginx demo site
      "sudo aws s3 cp s3://bcaa-demo-s3bucket/index.html /tmp/index.html",
      "sudo sed -i 's|##INDEX|${count.index+1}|g' /tmp/index.html",
      "sudo sed -i 's|##IP|${element(aws_instance.demo.*.private_ip, count.index)}|g' /tmp/index.html",
      "sudo mkdir -p /home/ubuntu/nginx-html",
      "sudo mv /tmp/index.html /home/ubuntu/nginx-html",
      "docker run -d -v `pwd`/nginx-html:/usr/share/nginx/html --name mynginx -p 80:80 nginx",

     # "echo '${element(aws_instance.demo.*.private_ip, count.index)}' > /tmp/myip",
     # "echo '${join(",", aws_instance.demo.*.private_ip)}' > /tmp/masterips",
    ]
  }
}



