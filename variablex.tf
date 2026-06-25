variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
    core_frac   = number   # Доля CPU (20, 50, 100)
    image_id    = string   # ID образа ОС
    zone        = string   # Зона доступности (ru-central1-a, b, c, d)
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 4
      disk_volume = 30
      core_frac   = 100
      image_id    = "fd80mrhj8fl2634m4165"
      zone        = "ru-central1-a"
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 20
      core_frac   = 20
      image_id    = "fd80mrhj8fl2634m4165"
      zone        = "ru-central1-a"
    }
  ]
}
