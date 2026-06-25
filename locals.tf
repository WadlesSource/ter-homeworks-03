locals {
  # Считываем публичный ключ один раз в локальную переменную
  ssh_public_key = file("/home/wadles/.ssh/id_ed25519")
}
