terraform {
  backend "azurerm" {
    resource_group_name  = "rg_vk"
    storage_account_name = "stgvkmyaml"
    container_name       = "tfstate"
    key                  = "preprod1.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
