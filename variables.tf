variable "project" {}

variable "credentials_file" {}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

variable "ssh_user" {
  default = "main"
}

variable "ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
}
