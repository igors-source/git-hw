
resource "yandex_compute_disk" "disk" {
  count = 3
  name = "disk-${count.index + 1}"

  type     = "network-hdd"
  size = 1
}

resource "yandex_compute_instance" "disk_vm" {
  name = "storage"

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
  dynamic "secondary_disk" {
    for_each = toset(yandex_compute_disk.disk.*.id)
    content {
      disk_id = secondary_disk.key
    }
  }
  scheduling_policy {
    preemptible = var.vm_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh_key
  }
}