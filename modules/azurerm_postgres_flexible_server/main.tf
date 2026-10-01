resource "azurerm_postgresql_flexible_server" "postgres" {
  for_each = var.postgresql_servers

  name                          = each.value.server_name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  version                       = "16"
  public_network_access_enabled = true
  administrator_login           = each.value.administrator_login
  administrator_password        = each.value.administrator_password
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P4"

  sku_name = "B_Standard_B1ms"
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  for_each  = var.postgresql_servers
  name      = each.value.database_name
  server_id = azurerm_postgresql_flexible_server.postgres[each.key].id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

# ---------------------------------------------------------------------
# Firewall rules - kaun se IPs PostgreSQL tak pahunch sakte hain
# ---------------------------------------------------------------------

# App VM ka public IP padho (naam tfvars ke app_vm_public_ip_name se)
data "azurerm_public_ip" "app_vm" {
  for_each            = var.postgresql_servers
  name                = each.value.app_vm_public_ip_name
  resource_group_name = each.value.resource_group_name
}

# Rule 1: backend VM (vm-app-02) -> PostgreSQL
resource "azurerm_postgresql_flexible_server_firewall_rule" "app_vm" {
  for_each         = var.postgresql_servers
  name             = "allow-vm-app-02"
  server_id        = azurerm_postgresql_flexible_server.postgres[each.key].id
  start_ip_address = data.azurerm_public_ip.app_vm[each.key].ip_address
  end_ip_address   = data.azurerm_public_ip.app_vm[each.key].ip_address
}

# Rule 2: tera laptop (pgAdmin) -> PostgreSQL
resource "azurerm_postgresql_flexible_server_firewall_rule" "my_laptop" {
  for_each         = var.postgresql_servers
  name             = "allow-my-laptop"
  server_id        = azurerm_postgresql_flexible_server.postgres[each.key].id
  start_ip_address = each.value.my_laptop_ip
  end_ip_address   = each.value.my_laptop_ip
}
