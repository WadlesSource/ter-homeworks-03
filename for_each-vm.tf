data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}
data "yandex_vpc_security_group" "default" {
  name = "example_dynamic"
}
resource "yandex_compute_instance" "db" {
  # Преобразуем list в map, где ключом будет имя ВМ
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  platform_id = "standard-v3"
  zone        = each.value.zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_frac
  }
 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.disk_volume
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id 
    nat                = true
    security_group_ids = data.yandex_vpc_security_group.default.id
  }

   metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}
