resource "local_file" "ansible_inventory" {
  filename = "./inventory.yml"
  content = templatefile("inventory.tftpl", {
    webservers = yandex_compute_instance.web,
    databases = yandex_compute_instance.for_each,
    storage = [yandex_compute_instance.disk_vm],
  })
}