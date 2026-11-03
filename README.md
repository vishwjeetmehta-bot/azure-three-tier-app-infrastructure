<div align="center">

# 🌐 Production 3-Tier Azure Infrastructure with Modular Terraform

[![Terraform](https://img.shields.io/badge/Terraform-Modular_IaC-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Azure-Three--Tier_Architecture-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL_Flexible-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](./LICENSE)

<p align="center">
  <b>Enterprise-ready 3-tier architecture provisioned with reusable Terraform modules: Presentation Layer (React / Nginx), Application Layer (FastAPI), and Data Layer (Azure Database for PostgreSQL Flexible Server).</b>
</p>

</div>

---

## 🏛️ Architecture Blueprint

```
                      ┌─────────────────────────────────────────┐
                      │             Internet Users              │
                      └────────────────────┬────────────────────┘
                                           │ HTTPS (Port 443 / 80)
                                           ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ Azure Virtual Network (10.0.0.0/16)                                                    │
│                                                                                        │
│  ┌─────────────────────────────────┐   HTTP:8000   ┌─────────────────────────────────┐ │
│  │ Tier 1: Frontend Subnet (10.0.1.0/24)│ ──────────> │ Tier 2: Backend Subnet (10.0.2.0/24)│ │
│  │  - VM: `vm-web-01` (Nginx + React)│             │  - VM: `vm-app-02` (FastAPI)     │ │
│  │  - NSG: Allowed 80, 443, 22     │             │  - NSG: Allowed 8000 (Internal)  │ │
│  └─────────────────────────────────┘             └────────────────┬────────────────┘ │
│                                                                   │ Port 5432         │
│                                                                   ▼                   │
│                                                  ┌─────────────────────────────────┐  │
│                                                  │ Tier 3: Database Subnet (10.0.3.0/24)│
│                                                  │  - Azure PostgreSQL Flexible v16│  │
│                                                  │  - Firewall Restricted to App VM│  │
│                                                  └─────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Provisioned Infrastructure Resources

| Resource Tier | Azure Component | Configuration Details |
| :--- | :--- | :--- |
| **Resource Group** | `rg-axion-update` | Primary region: East US |
| **Networking** | `vnet-axion-landingzone` | Address Space: `10.0.0.0/16` with subnets `/24` |
| **Presentation Tier** | `vm-web-01` | Ubuntu Linux, Nginx Web Server hosting React frontend |
| **Application Tier** | `vm-app-02` | Ubuntu Linux, Systemd managed FastAPI query service |
| **Database Tier** | Azure PostgreSQL Flexible | Engine v16, SKU B1ms, Restricted Firewall Rules |
| **State Storage** | Azure Blob Storage Backend | Encrypted remote state management (`stgvkmyaml`) |

---

## 📁 Repository Layout

```
azure-three-tier-app-infrastructure/
├── environment/
│   └── dev/                    # Environment composition layer
│       ├── main.tf             # Module invocations
│       ├── provider.tf         # AzureRM provider & backend configuration
│       ├── variable.tf         # Input variable definitions
│       └── terraform.tfvars    # Environment parameter values
├── modules/                    # Reusable enterprise modules
│   ├── azurerm_resource_group/
│   ├── azurerm_virtual_network/
│   ├── azurerm_subnets/
│   ├── azurerm_public_ip/
│   ├── azurerm_linux_virtual_machine/
│   └── azurerm_postgres_flexible_server/
└── README.md
```

---

## ⚡ Deployment Instructions

```bash
# 1. Authenticate to Azure
az login

# 2. Navigate to target environment
cd environment/dev

# 3. Initialize & Deploy
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

---

## 👤 Author

**Vishwjeet Kumar Mehta**  
Senior DevOps & DevSecOps Consultant | Cloud & Infrastructure Architect  
- **LinkedIn**: [linkedin.com/in/vishwjeetmehta](https://linkedin.com/in/vishwjeetmehta)  
- **GitHub**: [@vishwjeetmehta-bot](https://github.com/vishwjeetmehta-bot)
