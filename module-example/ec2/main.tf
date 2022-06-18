
resource "aws_security_group" "developer" {
  name        = "allow"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_instance" "web" {
  ami                         = local.ami-id
  instance_type               = var.instance_type
  key_name                    = var.ssh-key-pair-name
  iam_instance_profile        = "ssm-instances"
  vpc_security_group_ids      = [aws_security_group.developer.id]
  root_block_device {
      volume_size           = 30
    # (8 unchanged attributes hidden)
  }
  provisioner "remote-exec" {
    inline = [
       "sudo yum update -y",   
       "sudo yum amazon-linux-extras install docker",
       "sudo yum install docker -y",
       "sudo usermod -aG docker $USER",
       "sudo chmod 666 /var/run/docker.sock",
       "sudo service docker start",
       "sudo systemctl enable docker.service",
       "sudo systemctl restart docker",
       "sudo yum install -y yum-utils",
       "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo",
       "sudo yum -y install terraform",
       "curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl",
       "chmod +x ./kubectl",
       "mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin",
       "echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc",
       "curl --silent --location \"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz\" | tar xz -C /tmp",
       "sudo mv /tmp/eksctl /usr/local/bin", 
       "echo 'deployment environment is ready !'"
    ]
      connection {
          type     = "ssh"
          user     = "ec2-user"
          private_key = var.ssh-private-key
          host     = self.public_ip
  }
    
  }
  tags = {
    Name = "${var.environment-prefix}-bastion"
  }
}

