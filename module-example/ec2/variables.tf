variable "environment-prefix" {
  type        = string
  description = "A prefix to be prepended to every resource name"
  default     = "ec2"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be attached to every resource"
  default     = {}
}



variable "ssh-key-pair-name" {
  type        = string
  description = "Name of an SSH key pair to use for login to bastion VM"
}

variable "ssh-private-key" {
  type        = string
  description = "Private key to use for login to bastion VM"
}
