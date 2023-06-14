terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
resource_group_name  = "tfstate"
      storage_account_name = "tfstate8454"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
  
}

provider "azurerm" {
  features {}

  subscription_id   = "10c1c1c4-c34c-4a6f-b4bd-8560ab234169"
  tenant_id         = "59be3f3f-69f1-4a70-8dc6-a711f0432c80"
  client_id         = "2175a83c-0b82-4e7d-a166-d6ce9447f723"
  client_secret     = "cAW8Q~wgod6iYeSWbS4kYY37hZLAyxTHWxwWPds0"
}

data "azurerm_client_config" "current" {}