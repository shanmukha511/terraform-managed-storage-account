data "azurerm_client_config" "current" {}

locals {
    principals = toset(var.principal_ids)
}

data "azuread_service_principal" "test" {
  application_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
}

resource "azurerm_storage_account" "example" {
  name                     = var.storageaccntname
  resource_group_name      = var.resourcegroupname
  public_network_access_enabled = false
  location                 = var.storagelocation
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
 }


resource "azurerm_key_vault" "example" {
  name                        = var.keyvaultname
  location                    = var.keyvaultlocation
  resource_group_name         = var.resourcegroupname
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.softdelete
  purge_protection_enabled    = false
  enable_rbac_authorization   = false
  sku_name                    = "standard"
   
   network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules     =  ["20.231.127.15"]
}

 access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "Delete"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set",
      "SetSAS",
      "GetSAS",
      "DeleteSAS",
      "Update",
      "RegenerateKey"
    ]
  }

}


resource "azurerm_role_assignment" "example" {
  for_each = local.principals  
  scope              = azurerm_key_vault.example.id
  role_definition_name = var.roledefname
  principal_id       = each.key
}


resource "azurerm_private_endpoint" "example" {
  name                = var.endpointname
  location            = var.keyvaultlocation
  resource_group_name = var.resourcegroupname
  subnet_id           = var.subnetid  
   private_service_connection {
    name                           = var.privateserviceconnectionname
    private_connection_resource_id = azurerm_key_vault.example.id
    is_manual_connection           = false
    subresource_names = ["Vault"]
  }
  
  }


data "azurerm_storage_account_sas" "example" {
  connection_string = azurerm_storage_account.example.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2021-04-30T00:00:00Z"
  expiry = "2023-04-30T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false  
}
}

resource "azurerm_role_assignment" "example1" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = data.azuread_service_principal.test.id
}

resource "azurerm_key_vault_managed_storage_account" "test" {
  name                         = var.managedstorageaccountname
  key_vault_id                 = azurerm_key_vault.example.id
  storage_account_id           = azurerm_storage_account.example.id
  storage_account_key          = var.keyname
  regenerate_key_automatically = true
  regeneration_period          = var.regenratioperiod
}

resource "azurerm_key_vault_managed_storage_account_sas_token_definition" "example" {
  name                       = var.sasdefinitionname
  validity_period            =  var.validityperiod
  managed_storage_account_id = azurerm_key_vault_managed_storage_account.test.id
  sas_template_uri           = data.azurerm_storage_account_sas.example.sas
  sas_type                   = "account"
}

 
