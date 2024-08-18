locals {
  ssh_key = "ubuntu:${file("./id_rsa.pub")}"
} 