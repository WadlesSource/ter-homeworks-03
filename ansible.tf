resource "local_file" "hosts_cfg" {
  filename = "${path.module}/hosts.ini"

  content = templatefile("${path.module}/hosts.tpl", {
    # Передаем список ВМ из count (динамически обработает любое количество)
    webservers = yandex_compute_instance.web
    
    # Передаем карту ВМ из for_each (динамически обойдет все элементы)
    databases  = yandex_compute_instance.db
    
    # Оборачиваем одиночную ВМ в список [ ], чтобы шаблон обрабатывал её циклом
    storage_vms = [yandex_compute_instance.storage_vm]
  })
}

