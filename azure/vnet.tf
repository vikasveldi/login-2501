# Create a resource group
resource "azurerm_resource_group" "lms-rg" {
  name     = "lms-resources"
  location = "East US"
}

# Create Virtual Network 
resource "azurerm_virtual_network" "lms-vnet" {
  name                = "lms-vnet"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create Web Subnet
resource "azurerm_subnet" "lms-web-sn" {
  name                 = "lms-web-subnet"
  resource_group_name  = azurerm_resource_group.lms-rg.name
  virtual_network_name = azurerm_virtual_network.lms-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create API Subnet
resource "azurerm_subnet" "lms-api-sn" {
  name                 = "lms-api-subnet"
  resource_group_name  = azurerm_resource_group.lms-rg.name
  virtual_network_name = azurerm_virtual_network.lms-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create DB Subnet
resource "azurerm_subnet" "lms-db-sn" {
  name                 = "lms-db-subnet"
  resource_group_name  = azurerm_resource_group.lms-rg.name
  virtual_network_name = azurerm_virtual_network.lms-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Web Public IP
resource "azurerm_public_ip" "lms-web-pip" {
  name                = "lms-web-public-ip"
  resource_group_name = azurerm_resource_group.lms-rg.name
  location            = azurerm_resource_group.lms-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "web"
  }
}

# API Public IP
resource "azurerm_public_ip" "lms-api-pip" {
  name                = "lms-api-public-ip"
  resource_group_name = azurerm_resource_group.lms-rg.name
  location            = azurerm_resource_group.lms-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "api"
  }
}

# Web Network Security Group
resource "azurerm_network_security_group" "lms-web-nsg" {
  name                = "lms-web-firewall"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name
}

# WEB NSG SSH Rule
resource "azurerm_network_security_rule" "lms-web-nsg-ssh" {
  name                        = "lms-web-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lms-rg.name
  network_security_group_name = azurerm_network_security_group.lms-web-nsg.name
}

# WEB NSG HTTP Rule
resource "azurerm_network_security_rule" "lms-web-nsg-http" {
  name                        = "lms-web-http"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lms-rg.name
  network_security_group_name = azurerm_network_security_group.lms-web-nsg.name
}

# API Network Security Group
resource "azurerm_network_security_group" "lms-api-nsg" {
  name                = "lms-api-firewall"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name
}

# API NSG SSH Rule
resource "azurerm_network_security_rule" "lms-api-nsg-ssh" {
  name                        = "lms-api-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lms-rg.name
  network_security_group_name = azurerm_network_security_group.lms-api-nsg.name
}

# API NSG HTTP Rule
resource "azurerm_network_security_rule" "lms-api-nsg-http" {
  name                        = "lms-api-http"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lms-rg.name
  network_security_group_name = azurerm_network_security_group.lms-api-nsg.name
}

# DB Network Security Group
resource "azurerm_network_security_group" "lms-db-nsg" {
  name                = "lms-db-firewall"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name
}

# DB NSG SSH Rule
resource "azurerm_network_security_rule" "lms-db-nsg-ssh" {
  name                        = "lms-db-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lms-rg.name
  network_security_group_name = azurerm_network_security_group.lms-db-nsg.name
}

# DB NSG POSTGRES Rule
resource "azurerm_network_security_rule" "lms-db-nsg-postgres" {
  name                        = "lms-db-postgres"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lms-rg.name
  network_security_group_name = azurerm_network_security_group.lms-db-nsg.name
}

# WEB NIC
resource "azurerm_network_interface" "lms-web-nic" {
  name                = "lms-web-nic"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lms-web-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lms-web-pip.id
  }
}

# WEB NIC NSG Association
resource "azurerm_network_interface_security_group_association" "lms-web-nic-nsg" {
  network_interface_id          = azurerm_network_interface.lms-web-nic.id
  network_security_group_id     = azurerm_network_security_group.lms-web-nsg.id
}

# API NIC
resource "azurerm_network_interface" "lms-api-nic" {
  name                = "lms-api-nic"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lms-api-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lms-api-pip.id
  }
}

# API NIC NSG Association
resource "azurerm_network_interface_security_group_association" "lms-api-nic-nsg" {
  network_interface_id          = azurerm_network_interface.lms-api-nic.id
  network_security_group_id     = azurerm_network_security_group.lms-api-nsg.id
}

# DB NIC
resource "azurerm_network_interface" "lms-db-nic" {
  name                = "lms-db-nic"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lms-db-sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

# DB NIC NSG Association
resource "azurerm_network_interface_security_group_association" "lms-db-nic-nsg" {
  network_interface_id          = azurerm_network_interface.lms-db-nic.id
  network_security_group_id     = azurerm_network_security_group.lms-db-nsg.id
}

# LMS WEB SERVER
resource "azurerm_linux_virtual_machine" "lms-web-server" {
  name                = "lms-web-server"
  resource_group_name = azurerm_resource_group.lms-rg.name
  location            = azurerm_resource_group.lms-rg.location
  size                = "Standard_F2"
  admin_username      = "ubuntu"
  custom_data         = filebase64("script.sh")
  network_interface_ids = [
    azurerm_network_interface.lms-web-nic.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}