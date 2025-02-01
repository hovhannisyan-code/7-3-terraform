data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}



resource "yandex_compute_instance" "vm_1" {
  name        = var.vms_params.vm_1.name #Имя ВМ в облачной консоли
  hostname    = var.vms_params.vm_1.hostname #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = var.vms_params.vm_1.platform_id #тип ВМ
  zone        = var.vms_params.vm_1.zone #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = var.vms_params.vm_1.cores
    memory        = var.vms_params.vm_1.memory
    core_fraction = var.vms_params.vm_1.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      type     = var.vms_params.vm_1.boot_disk.type
      size     = var.vms_params.vm_1.boot_disk.size
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = var.vms_params.vm_1.preemptible }

  network_interface {
    subnet_id          = yandex_vpc_subnet.vm_1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id, yandex_vpc_security_group.ssh.id]
  }
}

resource "local_file" "inventory" {
  content  = <<-XYZ
  [vms]
  ${yandex_compute_instance.vm_1.network_interface.0.nat_ip_address} ansible_user=user
  XYZ
  filename = "./hosts"
}