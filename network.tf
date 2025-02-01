#создаем облачную сеть
resource "yandex_vpc_network" "vm_1" {
  name = "vm-1-${var.env}"
}

#создаем подсеть zone A
resource "yandex_vpc_subnet" "vm_1" {
  name           = "vm-1-${var.env}-${var.vms_params.vm_1.zone}"
  zone           = var.vms_params.vm_1.zone
  network_id     = yandex_vpc_network.vm_1.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  #route_table_id = yandex_vpc_route_table.rt.id
}


#создаем NAT для выхода в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "gateway-${var.env}"
  shared_egress_gateway {}
}

#создаем сетевой маршрут для выхода в интернет через NAT
resource "yandex_vpc_route_table" "rt" {
  name       = "route-table-${var.env}"
  network_id = yandex_vpc_network.vm_1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

#создаем группы безопасности(firewall)

resource "yandex_vpc_security_group" "ssh" {
  name       = "ssh-sg-${var.env}"
  network_id = yandex_vpc_network.vm_1.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}


resource "yandex_vpc_security_group" "LAN" {
  name       = "lan-sg-${var.env}"
  network_id = yandex_vpc_network.vm_1.id
  ingress {
    description    = "Allow 10.0.0.0/8"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.0.0/8"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg-${var.env}"
  network_id = yandex_vpc_network.vm_1.id


  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


}