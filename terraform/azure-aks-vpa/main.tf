resource "random_id" "prefix" {
  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = coalesce(var.resource_group_name, "${random_id.prefix.hex}-rg")
}

locals {
  resource_group = {
    name     = var.create_resource_group ? azurerm_resource_group.main[0].name : var.resource_group_name
    location = var.location
  }
}

resource "azurerm_virtual_network" "test" {
  address_space       = ["10.52.0.0/16"]
  location            = local.resource_group.location
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = local.resource_group.name
}

resource "azurerm_subnet" "test" {
  address_prefixes                          = ["10.52.0.0/24"]
  name                                      = "${random_id.prefix.hex}-sn"
  resource_group_name                       = local.resource_group.name
  virtual_network_name                      = azurerm_virtual_network.test.name
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "prefix2-${random_id.prefix.hex}"
  location            = local.resource_group.location
  resource_group_name = local.resource_group.name
  dns_prefix          = "prefix2-${random_id.prefix.hex}"

  workload_autoscaler_profile {
    vertical_pod_autoscaler_enabled = true
  }

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}
