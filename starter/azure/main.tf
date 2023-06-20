data "azurerm_resource_group" "udacity" {
  name     = "Regroup_0mXxBcusoTuwyCIv9b"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-cfav-azure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/cfav/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-cfav-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-cfav-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######


resource "azurerm_sql_server" "udacity_app" {
  name                         = "udacity-cfav-azure-sql"
  resource_group_name          = data.azurerm_resource_group.udacity.name
  location                     = data.azurerm_resource_group.udacity.location
  version                      = "12.0"

  tags = {
    environment = "udacity"
  }
}

resource "azurerm_service_plan" "udacity" {
  name                = "udacity-cfav-azure-service-plan"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "udacity" {
  name                = "udacity-cfav-azure-dotnet-app"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_service_plan.udacity.location
  service_plan_id     = data.azurerm_service_plan.udacity.id

  site_config {}
}