data "yandex_compute_image" "ubuntu" {
  family = var.vm_os_family
}

resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.for_each]
  count = 2
  name = "web-${count.index + 1}"
  platform_id =  var.vm_platform_id
  resources {
        cores = var.vms_resources.cores
        memory = var.vms_resources.memory
        core_fraction = var.vms_resources.core_fraction
  }

  boot_disk {
        initialize_params {
        image_id = data.yandex_compute_image.ubuntu.image_id
        }
  }
  
  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat     = true
        security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
        ssh-keys = local.ssh_key
        serial-port-enable = 1
  }
}