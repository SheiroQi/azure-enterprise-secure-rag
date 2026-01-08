terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # 锁定版本，避免未来自动更新再次导致语法不兼容
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

# 1. 生成随机后缀 (保证全球唯一命名，避免命名冲突报错)
resource "random_id" "suffix" {
  byte_length = 4
}

# 2. 资源组
resource "azurerm_resource_group" "rg" {
  name     = "rg-secure-rag-demo"
  location = "eastus2" # East US 2 对 OpenAI 模型支持较好
}

# 3. Virtual network
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

# 4. Azure OpenAI 服务账号
resource "azurerm_cognitive_account" "openai" {
  name                = "oai-secure-demo-${random_id.suffix.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "OpenAI"
  sku_name            = "S0"

  # 设置自定义子域名
  custom_subdomain_name = "oai-secure-demo-${random_id.suffix.hex}"

  # 为暂时允许公网访问
  # 生产环境设为 false
  public_network_access_enabled = true
}

# 5. 部署 GPT 模型
resource "azurerm_cognitive_deployment" "gpt_model" {
  name                 = "gpt-4o-mini" 
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    # 当前的 Default GA 版本
    version = "2024-07-18"
  }

  sku {
    name     = "Standard"
    capacity = 100 # gpt-4o-mini (100k TPM)
  }
}

# 6. Private Endpoint
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

# 7. 输出信息 (供 Python 代码使用)
output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

output "openai_key" {
  value     = azurerm_cognitive_account.openai.primary_access_key
  sensitive = true
}