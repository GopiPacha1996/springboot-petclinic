
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
    key_name = "tf-key-new"
    public_key =  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCwZ9gsA5ue82Pe1Ma02SKICyeZWE4qOMcM/zUrHMZC1iCcSvIShkTapT8VgiTObCP4blnGydLro/xpkCmLn0G5ZHs+nCjupEZb0wtNP/FFLzPyvHUZn5j8tc+QVsTZiEJd8SYPOjupYeXRzrzz4Z3zDe8l1lBD+wiwvP1GwMYFJUw3WpKb4Z5uA9uO05Dtc1pEUzOR5C2h6fuoa9nPj9KV/I5lnxFvJb0eC++qfE9X+BocbV/3tQzYtbrYimI7ZWCAEIHzfI42Q1sU7A9mVG7RBPeRqog/lqJdcfBI+vkWuL3hiSgoaVhImivbNYaaUU3Z262TSWX9aQZ9Qp1opxDfloyVp27yFwSTufiilv40IyNM+B8dqsRL8ITiRaaUgdc10CP8/jdpX95EgNuhvaZ4A5CTKZ+FoWhQ1CxgHWGoEa4t1yLo1BOGLElglLDfyQctjoIvUm2RHzv58WSNr718saf2+rCcJbVUl7KIAglbFd70Oq+5bA/yiywg9U2BdvE= ubuntu@ip-172-31-89-87"
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
      command = "echo ${self.public_ip} > /home/ubuntu/hosts/inventory"
  }
}

