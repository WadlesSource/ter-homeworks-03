resource "yandex_compute_instance" "web" {
  # Задаем цикл на создание 2 экземпляров
  count = 2

  # Именование ВМ с 1: web-1, web-2
  name        = "web-${count.index + 1}"
  platform_id = "standard-v3"

  depends_on = [yandex_compute_instance.db]

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id 
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id 
    nat       = true                                

    # Привязка группы безопасности
    security_group_ids = data.yandex_vpc_security_group.default.id
  }

  metadata = {
     ssh-keys = "ubuntu:${local.ssh_public_key}" 
  }
}
