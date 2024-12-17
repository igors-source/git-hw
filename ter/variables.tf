variable "yandex_cloud_token" {
  type = string
  description = "Введите секретный токен от yandex_cloud"
}


variable "vm_resources" { 
  type         = map(map(number))
  default      = {
    nat_res = {
      cores = 1
      memory = 2
      core_fraction = 20
      disk_size = 20
    }
    priv_res = {
      cores = 1
      memory=2
      core_fraction=20
      disk_size = 20
    }
  }
}