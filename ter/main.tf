terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yandex_cloud_token 
  cloud_id  = "b1gi9apmglo1h670hla4"
  folder_id = "b1gd6mkmc0olqg7vk03m"
  zone      = "ru-central1-a"
}

resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "b1gd6mkmc0olqg7vk03m"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
}
####################################################################################################
#                                   сети и подсети маршруты
####################################################################################################
#сеть
resource "yandex_vpc_network" "homework-net" {
  name = "homework-vpc"
}
#подсеть паблик
resource "yandex_vpc_subnet" "public" {
  name           = "public_subnet"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.homework-net.id
}
#подсеть private
resource "yandex_vpc_subnet" "private" {
  name           = "private_subnet"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.homework-net.id
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}
#маршрут
resource "yandex_vpc_route_table" "nat-instance-route" {
  name       = "route_table"
  network_id = yandex_vpc_network.homework-net.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}
####################################################################################################
#                                   диски и инстансы
####################################################################################################
#диск нат
resource "yandex_compute_disk" "disk-nat" {
  name     = "disk-nat"
  zone     = "ru-central1-a"
  size     = 20
  image_id = "fd80mrhj8fl2oe87o4e1"
}

#Нат инстанс
resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-inst"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk-nat.id
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat       = true
  }

  metadata = {
    user-data = "${file("./metadata.yml")}"
  }
}

resource "yandex_compute_disk" "disk-public" {
  name     = "disk-public"
  zone     = "ru-central1-a"
  size     = 20
  image_id = "fd8tiutrcvb5e2jd9d0q"
}
#public vm
resource "yandex_compute_instance" "vm-public" {
  name        = "vm_public"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk-public.id
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.250"
    nat       = true
  }

  metadata = {
    user-data = "${file("./metadata.yml")}"
  }
}
# private vm
resource "yandex_compute_disk" "disk-private" {
  name     = "disk-private"
  zone     = "ru-central1-a"
  size     = 20
  image_id = "fd8tiutrcvb5e2jd9d0q"
}

resource "yandex_compute_instance" "vm-private" {
  name        = "vm_private"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk-private.id
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.private.id
    ip_address = "192.168.20.250"
    nat       = false
  }

  metadata = {
    user-data = "${file("./metadata.yml")}"
  }
}