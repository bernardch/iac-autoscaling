# Azure: Container Apps on VMSS (Dedicated workload profile)
cloud                     = "azure"
project_name               = "terraform_demo"
min_size                   = 1
max_size                   = 3
scale_target_value         = 30.0
azure_resource_group_name  = "terraform_demo"
azure_location             = "canadacentral"
azure_container_image      = "demopython.azurecr.io/demo-python:latest"
azure_acr_login_server     = "demopython.azurecr.io"
azure_dedicated_profile_name = "dedicated"
azure_dedicated_profile_type = "D4"

# Required: full resource ID of your ACR
azure_acr_id = "/subscriptions/e437dec0-68fc-45a7-bfa2-34c7d277f724/resourceGroups/terraform_shared/providers/Microsoft.ContainerRegistry/registries/demopython"
