###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
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

### Виртуалки

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Distro type"
}

variable "vms_resources" {
  description = "Resources for all vms"
  type        = map(number)
  default     = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "platform type"
}

variable "vm_preemptible" {
  type        = bool
  default     = true
  description = "preemptibles"
}

variable "each_vm" {
  type = list(object({vm_name=string,cpu=number, ram=number, disk=number}))
  default = [
    {  vm_name="main",cpu=2, ram=1, disk=10 },
    {  vm_name="replica",cpu=4, ram=2, disk=20 }
  ]
} 

variable "disk_vm_count" {
  type = string
  default = "3"
}

variable "disk_vm_size" {
  type = string
  default = "1"
}

