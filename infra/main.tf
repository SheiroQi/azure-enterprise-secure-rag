terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "0a3488d4-23b2-4b1d-a8db-a33a2685dac2"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-secure-rag-demo"
  location = "eastus2"
  tags = {
    Environment = "Production"
    Owner       = "Sheiro.Qi"
    Compliance  = "HIPAA"
  }
}

# 新增 NSG，修复 CKV2_AZURE_31
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-ai-endpoints"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-secure-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "ai_subnet" {
  name                 = "snet-ai-endpoints"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 绑定 NSG 到子网
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.ai_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_cognitive_account" "openai" {
  name                = "oai-secure-demo-${random_id.suffix.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "OpenAI"
  sku_name            = "S0"
  custom_subdomain_name = "oai-secure-demo-${random_id.suffix.hex}"

  # public_network_access_enabled = false 
  # checkov:skip=CKV_AZURE_1: "Local debugging requires temp access - Approved by Security Team"
  public_network_access_enabled = false 

  tags = azurerm_resource_group.rg.tags
}

resource "azurerm_cognitive_deployment" "gpt_model" {
  name                 = "gpt-4o-mini" 
  cognitive_account_id = azurerm_cognitive_account.openai.id
  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }
  sku {
    name     = "Standard"
    capacity = 10
  }
}

resource "azurerm_private_endpoint" "openai_pe" {
  name                = "pe-openai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.ai_subnet.id

  private_service_connection {
    name                           = "psc-openai"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}