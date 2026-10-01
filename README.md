# Axion Server Infra (Terraform, Azure)

3-tier Axion app ka infra: React UI → FastAPI → Azure PostgreSQL.

## Kya banta hai

| Resource | Naam | Detail |
|---|---|---|
| Resource Group | `rg-axion-update` | East US |
| VNet | `vnet-axion-landingzone` | 10.0.0.0/16 |
| Subnets | `snet-frontend-01`, `snet-backend-02`, `snet-db-03` | 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 (db abhi khaali) |
| VM web | `vm-web-01` + `pip-vm-01` | NSG: 22, 80 (Nginx + React build) |
| VM app | `vm-app-02` + `pip-vm-02` | NSG: 22, 8000 (query service). 8001 ingestion + simulator internal |
| PostgreSQL | `pgsql-axion-sandbox-vkm-01` / db `vkmaxiondb` | Flexible v16, B1ms, Central India. Firewall: app VM IP (+ laptop) |

State: Azure Storage backend (`rg_vk / stgvkmyaml / tfstate / preprod1.terraform.tfstate`).

## Structure

```
environment/dev/   main.tf, provider.tf, variable.tf, terraform.tfvars
modules/           resource_group, virtual_network, subnets, public_ip,
                   linux_virtual_machine (NIC + NSG + VM),
                   postgres_flexible_server (server + db + firewall rules)
```

VM ka app port: `terraform.tfvars` → VM ka `app_port` (web = 80, app = 8000).
DB firewall: `postgresql_servers.pgsql1` → `app_vm_public_ip_name` (app VM) aur `my_laptop_ip` (pgAdmin).

## Run

```powershell
cd environment/dev
az login
terraform init
terraform validate
terraform plan
terraform apply
```

## Infra ke baad

1. pgAdmin → `vkmaxiondb` → official schema (`axion-database-schema`, `timestamp` = TIMESTAMP bina TZ)
2. vm-app-02: query service :8000, ingestion :8001, simulator → systemd
3. vm-web-01: axion-ui → `API_BASE` = `http://<pip-vm-02>:8000` → `npm run build` → Nginx
