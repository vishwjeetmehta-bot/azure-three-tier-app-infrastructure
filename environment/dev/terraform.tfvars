resource_groups = {
  "rg-dev" = {
    name     = "rg-axion-update"
    location = "East US"
  }
}

virtual_networks = {
  "vnet-dev" = {
    name                = "vnet-axion-landingzone"
    location            = "East US"
    resource_group_name = "rg-axion-update"
    address_space       = ["10.0.0.0/16"]
  }
}

subnets = {
  "snet-web-01" = {
    name                 = "snet-frontend-01"
    resource_group_name  = "rg-axion-update"
    virtual_network_name = "vnet-axion-landingzone"
    address_prefixes     = ["10.0.1.0/24"]
  }
  "snet-app-02" = {
    name                 = "snet-backend-02"
    resource_group_name  = "rg-axion-update"
    virtual_network_name = "vnet-axion-landingzone"
    address_prefixes     = ["10.0.2.0/24"]
  }
  "snet-db-03" = {
    name                 = "snet-db-03"
    resource_group_name  = "rg-axion-update"
    virtual_network_name = "vnet-axion-landingzone"
    address_prefixes     = ["10.0.3.0/24"]
  }
}

public_ips = {
  "pip-vm-01" = {
    name                = "pip-vm-01"
    location            = "East US"
    resource_group_name = "rg-axion-update"
    allocation_method   = "Static"
  }
  "pip-vm-02" = {
    name                = "pip-vm-02"
    location            = "East US"
    resource_group_name = "rg-axion-update"
    allocation_method   = "Static"
  }
  # "pip-vm-03" = {
  #   name                = "pip-vm-03"
  #   location            = "East US"
  #   resource_group_name = "rg-axion-update"
  #   allocation_method   = "Static"
  # }
}

linux_vms = {
  "vm-01" = {
    name                 = "vm-web-01"
    location             = "East US"
    resource_group_name  = "rg-axion-update"
    virtual_network_name = "vnet-axion-landingzone"
    subnet_name          = "snet-frontend-01"
    public_ip_name       = "pip-vm-01"
    nic_name             = "nic-vm-01"
    admin_username       = "vkmadminuser"
    admin_password       = "Password@12345"
    app_port             = "80" # Nginx (frontend)
  }
  "vm-02" = {
    name                 = "vm-app-02"
    location             = "East US"
    resource_group_name  = "rg-axion-update"
    virtual_network_name = "vnet-axion-landingzone"
    subnet_name          = "snet-backend-02"
    public_ip_name       = "pip-vm-02"
    nic_name             = "nic-vm-02"
    admin_username       = "vkmadminuser"
    admin_password       = "Password@12345"
    app_port             = "8000" # FastAPI query service
  }
  # "vm-03" = {
  #   name                 = "vm-db-03"
  #   location             = "East US"
  #   resource_group_name  = "rg-axion-update"
  #   virtual_network_name = "vnet-axion-landingzone"
  #   subnet_name          = "snet-db-03"
  #   public_ip_name       = "pip-vm-03"
  #   nic_name             = "nic-vm-03"
  #   admin_username       = "vkmadminuser"
  #   admin_password       = "Password@12345"
  # }
}

postgresql_servers = {
  pgsql1 = {
    server_name            = "pgsql-axion-sandbox-vkm-01"
    resource_group_name    = "rg-axion-update"
    location               = "Central India"
    administrator_login    = "vkmadminuser"
    administrator_password = "Password@12345"
    database_name          = "vkmaxiondb"
    app_vm_public_ip_name  = "pip-vm-02"     # is IP ko DB firewall me allow karega
    my_laptop_ip           = "49.36.215.15"  # pgAdmin ke liye (badle to: curl.exe ifconfig.me)
  }
}
