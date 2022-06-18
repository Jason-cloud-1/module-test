data "aws_region" "current" {}

locals {
  ami-id = data.aws_ami.amazonlinux2.image_id
}

data "aws_ami" "amazonlinux2" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] # Canonical
}
