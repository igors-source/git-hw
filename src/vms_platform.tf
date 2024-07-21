###vm1 vars

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "distro family"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "instance name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platform type"
}
/*
variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "cores"
}

variable "vm_web_memory" {
  type        = number
  default     = 2
  description = "mem"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 20
  description = "cores"
}
*/
variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "preemptibles"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "nat"
}
##vm2 vars

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "distro family"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "instance name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platform type"
}
/*
variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "cores"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "mem"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "cores"
}
*/
variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "preemptibles"
}

variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "nat"
} 


#new subnet

variable "default_zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr_b" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
variable "vpc_name_b" {
  type        = string
  default     = "develop_b"
  description = "VPC network & subnet name"
}


variable "vms_resources" {
  description = "Resources for all vms"
  type        = map(map(number))
  default     = {
    vm_web = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
    vm_db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "metadata" {
  description = "ssh key"
  type        = map(string)
  default     = {
    serial-port-enable = "1"
    ssh-keys          = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeta6lUwlQcKI77QSaTT6WygO5VQ3mQ/2F/5zcr5vFCtophPffKpuGeg/fBworSEYGbfWSzvce+F6OhMlPjgdehagprp2L+QCRnIWhLH7s7bTq4jt4T9VzAnGcSi1z6rs1pEMUWoNuMX+rB+5FeFtXxFF7l5zHW2sx/5CNIWSm971eLX/If+x0E4P9l9DdgAO1bInrfB0ynuzw//mzex97n6u2QE7hS5iOIRpEOi/lr3PzOXyZhZvS5QCElvODEmZwOex894+5TYFJTcYA99Zugcp+z7sHVK1HN7Jxs1Tp7/3LTuzD3UO31tIMpBzS0YnUIfKMKzHvHM7ZKxhnLpftVZ9EWbJ3KF3+q8GFTBG7czudO4x7Q9PSIRX9strYXz3QzcSNumpfwgG3D0gvPUkZR/IXXBSafhKeLIMJzgr2tp9BjVw3sfGaYZCmb30q2B24D3jHrvhF1fA0vZ1dqqqI4CdfiiVSs4vRBPAlU8idX9HrXlmTlW5VoznHEb+32+k= motorher@DESKTOP-NGLG1VS"
  }
}
