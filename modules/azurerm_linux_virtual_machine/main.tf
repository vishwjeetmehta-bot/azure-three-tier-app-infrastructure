

# Network Security Group with Port 22 SSH rule
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.linux_vms
  name                = "nsg-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "Allow-SSH-Port-22"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # App ka port (web: 80, app: 8000) - tfvars ke app_port se
  security_rule {
    name                       = "allow-${each.value.app_port}"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = each.value.app_port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Interfaces
resource "azurerm_network_interface" "nic" {
  for_each            = var.linux_vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.pip[each.key].id
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  for_each                  = var.linux_vms
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Linux Virtual Machines
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.linux_vms
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  size                            = "Standard_DC1ds_v3"
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
