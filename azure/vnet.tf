# Create a resource group
resource "azurerm_resource_group" "lms-rg" {
  name     = "lms-resources"
  location = "East US"
}
