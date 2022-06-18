data "aws_region" "current" {}

locals {
  ami-id = data.aws_ami.amazonlinux2.image_id
}

data "aws_ami" "amazonlinux2" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
