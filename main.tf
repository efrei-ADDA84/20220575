provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "dzung_resource_group" {
  name     = "ADDA84-CTP"
}

data "azurerm_virtual_network" "dzung_virtual_network" {
  name                = "network-tp4"
  resource_group_name = data.azurerm_resource_group.dzung_resource_group.name
}

data "azurerm_subnet" "dzung_subnet" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.dzung_resource_group.name
  virtual_network_name = data.azurerm_virtual_network.dzung_virtual_network.name
}

resource "azurerm_public_ip" "dzung_public_ip" {
  name                = "dzung-publicip-tp4"
  location            = data.azurerm_resource_group.dzung_resource_group.location
  resource_group_name = data.azurerm_resource_group.dzung_resource_group.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "dzung_network_interface" {
  name                = "dzung-nic-tp4"
  location            = data.azurerm_resource_group.dzung_resource_group.location
  resource_group_name = data.azurerm_resource_group.dzung_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.dzung_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dzung_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "dzung_linux_virtual_machine" {
  name                = "devops-20220575"
  location            = data.azurerm_resource_group.dzung_resource_group.location
  resource_group_name = data.azurerm_resource_group.dzung_resource_group.name
  size                = "Standard_D2s_v3"
  admin_username      = "devops"
  network_interface_ids = [
    azurerm_network_interface.dzung_network_interface.id,
  ]

  os_disk {
    name              = "dzung-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username       = "devops"
    public_key     = file("~/educations/m1-efrei/devops/20220575/id_rsa.pub")
  }
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.dzung_linux_virtual_machine.public_ip_address
}