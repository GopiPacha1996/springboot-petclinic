
data "aws_ami" "my-image" {
    most_recent = true
    owners = ["099720109477"]
    
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  } 
}

resource "aws_default_security_group" "demo-sg" {
    vpc_id = var.vpc
    ingress {
    description      = "for HTTP requests"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "for ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
      Name = "${var.env}-sg"
  }
}

resource "aws_key_pair" "my-key" {
    key_name = "tf-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3k8k8te0lV/rhK51gEzbvoFWOo4TxExKT9bQ/AjLiHLzY6c9uS25GMkXcPXEr/HoT62c0stvYCTvrkETq/iqjY9qrNWDhWI5WrkXzV3Sv1nIHNMcFX6rAUmZuQ+2ID0nzVu6hzLB4aYuaPEnBG9HtQAq76EGMBLmMp3BU7rTdgfG7MAdDDNzBHiXlLYP/hVt9wYqFX/ObK/IpPFf60ktBs54KXFHir8ZSS3LpIp/7B0jAb1CASAdi0e14Flx9F0pw5qeDcoOk7f/33m0W0KpMd1aDPGS/k1jLGpQpEoElVEffzfRJdcqrFYKiEr9aHaf20bmBhYbBEdpsHcjPhULZ0m6R2CbDksR/bvg/kQaecxmicRh8dSebbEH+/CFU0yteBiAmfdct4gj28URS09uOTF4QJswZULDIMGckY+hhofyYqcFMXMmSKNJRl+dz6px10F2QU6+8SIM7aTtr1lvwi/vD5YOi3iAbvaUcJtKhIAjePq1Bmv3v6E9ZKsXkbPE= srpen@SriniPersonal"
}

resource "aws_instance" "demoinstance"{
    ami = data.aws_ami.my-image.id
    instance_type= var.instance_type
    availability_zone = var.avail_zone
    key_name = aws_key_pair.my-key.key_name
    vpc_security_group_ids = [aws_default_security_group.demo-sg.id]
    subnet_id = var.snet_id
    associate_public_ip_address = true
    tags = {
        Name = "${var.env}-ec2"
    }
     provisioner "local-exec" {
      command = "echo ${self.public_ip} > hosts"
  }
}

