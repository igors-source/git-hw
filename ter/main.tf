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
  name        = "ig-sa-id"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "b1gd6mkmc0olqg7vk03m"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"
}

#Ключи
resource "yandex_iam_service_account_static_access_key" "sa-key" {
  service_account_id = yandex_iam_service_account.ig-sa.id
  description        = "storage key"
}

#создать бакет
resource "yandex_storage_bucket" "shadrine" {
  access_key = yandex_iam_service_account_static_access_key.sa-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-key.secret_key
  bucket     = "bucket-for-kotishe-picture"
  acl    = "public-read"
  max_size   = 1073741824
  website {
    index_document = "silk.jpg"
  }

  anonymous_access_flags {
    read        = true
    list        = true
    config_read = true
  }
}
resource "yandex_storage_object" "kotishe" {
  access_key = yandex_iam_service_account_static_access_key.sa-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-key.secret_key
  bucket = yandex_storage_bucket.shadrine.id
  key    = "silk.jpg"
  source = "./img/silk.jpg"
  tags = {
    test = "value"
  }
}

#сеть
resource "yandex_vpc_network" "homework-net-1" {
  name = "homework-vpc-1"
}
#подсеть паблик
resource "yandex_vpc_subnet" "public" {
  name           = "public_subnet"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.homework-net-1.id
}

#вычислительная группа
resource "yandex_compute_instance_group" "groupodin" {
  name                = "gr1"
  folder_id           = "b1gd6mkmc0olqg7vk03m"
  service_account_id  = yandex_iam_service_account.ig-sa.id
  deletion_protection = false
  depends_on          = [yandex_resourcemanager_folder_iam_member.editor]
  instance_template {
    platform_id = "standard-v3"
    resources {
      core_fraction = 20
      memory        = 4
      cores         = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 20
      }
    }

    scheduling_policy {
      preemptible = true
    }


    network_interface {
      network_id         = "${yandex_vpc_network.homework-net-1.id}"
      subnet_ids         = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
    }
    metadata = {
      user-data = "${file("./metadata.yml")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  # zone = "ru-central1-a"
  allocation_policy {
      zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 3
    max_creating    = 3
    max_expansion   = 3
    max_deleting    = 3
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Network Load Balancer"
  }

}

resource "yandex_lb_network_load_balancer" "bal-1" {
  name = "bal-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.groupodin.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}