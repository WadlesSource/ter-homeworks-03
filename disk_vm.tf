resource "yandex_compute_disk" "storage" {
  # Задаем цикл на создание 3 экземпляров
  count = 3

  # Именование дисков: disk-1, disk-2, disk-3
  name = "disk-${count.index + 1}"
  
  # Зона доступности
  zone = "ru-central1-a"
  
  # Размер диска в Гб
  size = 1
  
  # Тип диска
  type = "network-hdd"
}

# Одиночная ВМ "storage" с динамическим подключением дополнительных дисков
resource "yandex_compute_instance" "storage_vm" {
  name        = "storage"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      # Используем тот же автоматический поиск образа
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  # Динамический блок для подключения всех 3 дисков
  dynamic "secondary_disk" {
    # Итерируемся по списку ID всех дисков, созданных через count
    for_each = yandex_compute_disk.storage[*].id

    content {
      disk_id = secondary_disk.value
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = ["enpf6932rkdif57f8vr2"]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}
