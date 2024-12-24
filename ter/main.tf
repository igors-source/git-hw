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
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-01.id
        sse_algorithm     = "aws:kms"
      }
    }
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



resource "yandex_kms_symmetric_key" "key-01" {
  name              = "homework-key"
  description       = "key for picture"
  default_algorithm = "AES_128"
  rotation_period   = "300h"
}