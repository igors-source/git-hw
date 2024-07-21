###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1g6fo99h0qim9jv8gnk"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g2495p8ldt10kjk28s"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeta6lUwlQcKI77QSaTT6WygO5VQ3mQ/2F/5zcr5vFCtophPffKpuGeg/fBworSEYGbfWSzvce+F6OhMlPjgdehagprp2L+QCRnIWhLH7s7bTq4jt4T9VzAnGcSi1z6rs1pEMUWoNuMX+rB+5FeFtXxFF7l5zHW2sx/5CNIWSm971eLX/If+x0E4P9l9DdgAO1bInrfB0ynuzw//mzex97n6u2QE7hS5iOIRpEOi/lr3PzOXyZhZvS5QCElvODEmZwOex894+5TYFJTcYA99Zugcp+z7sHVK1HN7Jxs1Tp7/3LTuzD3UO31tIMpBzS0YnUIfKMKzHvHM7ZKxhnLpftVZ9EWbJ3KF3+q8GFTBG7czudO4x7Q9PSIRX9strYXz3QzcSNumpfwgG3D0gvPUkZR/IXXBSafhKeLIMJzgr2tp9BjVw3sfGaYZCmb30q2B24D3jHrvhF1fA0vZ1dqqqI4CdfiiVSs4vRBPAlU8idX9HrXlmTlW5VoznHEb+32+k= motorher@DESKTOP-NGLG1VS"
  description = "ssh-keygen -t ed25519"
}
