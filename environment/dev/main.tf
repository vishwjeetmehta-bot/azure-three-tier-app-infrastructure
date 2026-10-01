module "azurerm_resource_group" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = var.resource_groups
}

module "azurerm_virtual_network" {
  source           = "../../modules/azurerm_virtual_network"
  virtual_networks = var.virtual_networks

  depends_on = [module.azurerm_resource_group]
}

module "azurerm_subnets" {
  source  = "../../modules/azurerm_subnets"
  subnets = var.subnets

  depends_on = [module.azurerm_virtual_network]
}

module "azurerm_public_ip" {
  source     = "../../modules/azurerm_public_ip"
  public_ips = var.public_ips

  depends_on = [module.azurerm_resource_group]
}

module "azurerm_linux_virtual_machine" {
  source    = "../../modules/azurerm_linux_virtual_machine"
  linux_vms = var.linux_vms

  depends_on = [
    module.azurerm_subnets,
    module.azurerm_public_ip
  ]
}

module "postgressql" {
  source             = "../../modules/azurerm_postgres_flexible_server"
  postgresql_servers = var.postgresql_servers

  # public_ip chahiye kyunki firewall rule app VM ka IP padhta hai
  depends_on = [
    module.azurerm_resource_group,
    module.azurerm_subnets,
    module.azurerm_public_ip
  ]
}
