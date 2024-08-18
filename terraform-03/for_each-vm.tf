resource "yandex_compute_instance" "for_each" {
  for_each = {
    main = var.each_vm[0]
    replica = var.each_vm[1]
  }
  name = "${each.value.vm_name}"
  platform_id =  var.vm_platform_id
  resources {
    cores = "${each.value.cpu}"
    memory = "${each.value.ram}"
    core_fraction = var.vms_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = "${each.value.disk}"
    }
  }
    scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = local.ssh_key
  }
}