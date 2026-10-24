resource "azurerm_network_interface" "main" {
  for_each = var.vms

  name                = "each.value.name"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  for_each = var.vms

  name                  = each.value.name
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main[each.key].id]
  size                  = "Standard_DS1_v2"

  admin_username                  = "testadmin"
  admin_password                  = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  
  
}

variable "admin_password" {
  type      = string
  sensitive = true
}