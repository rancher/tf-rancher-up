locals {
  private_ssh_key_path    = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  public_ssh_key_path     = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  resource_group_location = var.create_rg ? azurerm_resource_group.rg[0].location : var.resource_group_location
  resource_group_name     = var.create_rg ? azurerm_resource_group.rg[0].name : var.resource_group_name
  os_image_publisher      = var.os_type == "sles" ? "suse" : "canonical"
  os_image_offer          = var.os_type == "sles" ? "sles-15-sp6-basic" : "0001-com-ubuntu-server-jammy"
  os_image_sku            = var.os_type == "sles" ? "gen1" : "22_04-lts"
  os_image_version        = "latest"
  ssh_username            = var.os_type
}

resource "tls_private_key" "ssh_private_key" {
  count     = var.create_ssh_key_pair ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "private_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.private_ssh_key_path
  content         = tls_private_key.ssh_private_key[0].private_key_openssh
  file_permission = "0600"
}

resource "local_file" "public_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.public_ssh_key_path
  content         = tls_private_key.ssh_private_key[0].public_key_openssh
  file_permission = "0600"
}

data "local_file" "public_key" {
  count    = var.create_ssh_key_pair ? 0 : 1
  filename = local.public_ssh_key_path
}

data "local_file" "private_key" {
  count    = var.create_ssh_key_pair ? 0 : 1
  filename = local.private_ssh_key_path
}

resource "random_string" "random" {
  length  = 4
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_rg ? 1 : 0
  name     = "${var.prefix}-rg"
  location = var.region
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.create_vnet ? 1 : 0
  name                = "${var.prefix}-vnet"
  address_space       = [var.ip_cidr_range]
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  depends_on           = [azurerm_virtual_network.vnet]
  count                = var.create_subnet ? 1 : 0
  name                 = "${var.prefix}-subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  address_prefixes     = [var.ip_cidr_range]
}

resource "azurerm_public_ip" "vm_ip" {
  depends_on          = [azurerm_subnet.subnet]
  count               = var.instance_count
  name                = "${var.prefix}-public-ip-${count.index + var.tag_begin}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nsg" {
  count               = var.create_firewall ? 1 : 0
  name                = "${var.prefix}-nsg"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
}

resource "azurerm_network_security_rule" "allow_inbound" {
  for_each = var.create_firewall ? toset([
    "22", "443", "6443", "2379", "2380", "8443", "9099", "10250", "10254",
    "2376", "30000-32767", "2375", "8472", "9345", "2381", "51820", "51821"
  ]) : []

  name = "${var.prefix}-allow-inbound-${each.key}"
  priority = 100 + index([
    "22", "443", "6443", "2379", "2380", "8443", "9099", "10250", "10254",
    "2376", "30000-32767", "2375", "8472", "9345", "2381", "51820", "51821"
  ], each.key)
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = each.key
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_network_security_rule" "allow_outbound" {
  count                       = var.create_firewall ? 1 : 0
  name                        = "${var.prefix}-allow-outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = local.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_network_interface" "nic" {
  depends_on          = [azurerm_public_ip.vm_ip]
  count               = var.instance_count
  name                = "${var.prefix}-nic-${count.index + var.tag_begin}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.create_subnet ? azurerm_subnet.subnet[0].id : var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  depends_on                = [azurerm_network_interface.nic]
  count                     = var.instance_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = var.create_firewall ? azurerm_network_security_group.nsg[0].id : var.network_security_group_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  depends_on          = [azurerm_network_interface_security_group_association.nsg_assoc]
  count               = var.instance_count
  name                = "${var.prefix}-vm-${count.index + var.tag_begin}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  size                = var.instance_type
  admin_username      = local.ssh_username
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]
  priority        = var.spot_instance ? "Spot" : "Regular"
  eviction_policy = var.spot_instance ? "Deallocate" : null
  admin_ssh_key {
    username   = local.ssh_username
    public_key = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].public_key_openssh : data.local_file.public_key[0].content
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.disk_type
    disk_size_gb         = var.instance_disk_size
  }
  source_image_reference {
    publisher = local.os_image_publisher
    offer     = local.os_image_offer
    sku       = local.os_image_sku
    version   = local.os_image_version
  }
  custom_data = var.startup_script != null ? base64encode(var.startup_script) : null
  connection {
    type        = "ssh"
    user        = local.ssh_username
    private_key = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].private_key_pem : data.local_file.private_key[0].content
    host        = azurerm_public_ip.vm_ip[count.index].ip_address
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}
