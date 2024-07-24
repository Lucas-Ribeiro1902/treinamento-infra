# Declara o provedor que será utilizado
provider "azurerm" {
  features {}
}

# Cria um grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "meu-grupo-de-recursos"
  location = "West US"
}

# Cria uma rede virtual
resource "azurerm_virtual_network" "vnet" {
  name                = "minha-rede-virtual"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Cria uma sub-rede
resource "azurerm_subnet" "subnet" {
  name                 = "minha-sub-rede"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Cria um endereço IP público
resource "azurerm_public_ip" "pip" {
  name                = "meu-endereco-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Cria uma interface de rede
resource "azurerm_network_interface" "nic" {
  name                = "minha-interface-de-rede"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "configuracao-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Cria uma VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "minha-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  size = "Standard_B1ls"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_username = "adminuser"
  admin_password = "AdminPassword123!"

  os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name  = "minha-vm"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/chave_ssh.pub")
  }
}

# Adiciona uma extensão para instalar o Docker na VM
resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                 = "instalar-docker"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<-SETTINGS
    {
        "commandToExecute": "apt-get update && apt-get install -y docker.io && systemctl start docker && systemctl enable docker && docker run -d -p 80:80 --name meu-wordpress-container wordpress"
    }
  SETTINGS
}
