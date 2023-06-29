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
       subscription_id   = "10c1c1c4-c34c-4a6f-b4bd-8560ab234169"
  }
  
}

provider "azurerm" {
  features {}

}



data "azurerm_client_config" "current" {}