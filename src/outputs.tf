output "VMs" {
  value = {
    instance_name = yandex_compute_instance.platform.name
    external_ip = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    fqdn = yandex_compute_instance.platform.fqdn
    instance_name_1 = yandex_compute_instance.platform_1.name
    external_ip_1 =  yandex_compute_instance.platform_1.network_interface.0.nat_ip_address
    fqdn_1 = yandex_compute_instance.platform_1.fqdn
  }
}