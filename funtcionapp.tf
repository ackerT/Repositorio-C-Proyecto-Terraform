resource "azurerm_service_plan" "function_plan" {
  name                = "asp-function-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"  

  tags = var.tags
}


resource "azurerm_linux_function_app" "asyncfunction" {
  name                       = "func-async-${var.project}-${var.environment}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.function_plan.id
  storage_account_name       = azurerm_storage_account.stoacc.name
  storage_account_access_key = azurerm_storage_account.stoacc.primary_access_key

 site_config {
   }
 
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    AzureWebJobsStorage      = azurerm_storage_account.stoacc.primary_connection_string
    QUEUE_NAME               = azurerm_storage_queue.qm.name
  }

  tags = var.tags
}
