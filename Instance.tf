resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "my-key"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  availability_zone      = "us-east-1a"


  tags = {
    Name = "web"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  connection {
    type        = "ssh"
    user        = var.webuser
    private_key = file("mykey")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> publicip.txt"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}

resource "aws_ec2_instance_state" "server-state" {
  instance_id = aws_instance.web.id
  state       = "running"
}

