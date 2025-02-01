variable "env" {
  type    = string
  default = "homework"
}

variable "cloud_id" {
  type    = string
  default = "b1gmsespcfpk191os44b"
}
variable "folder_id" {
  type    = string
  default = "b1ge7gq7j1tek5bcjla3"
}

variable "vms_params" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    name          = string
    hostname      = string
    zone          = string
    platform_id   = string
    boot_disk     = object({
      size = number
      type = string
    })    
  }))
  default = {
    vm_1 = {
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      name          = "vm-1"
      hostname      = "vm-1"
      zone          = "ru-central1-a"
      platform_id   = "standard-v3"
      boot_disk     = {
        size     = 10
        type     = "network-hdd"
      }

    }
  }
}
