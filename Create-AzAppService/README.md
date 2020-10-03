[Previous page >](../)

Content
------------
This script create an App Service plan, an App Service and its Private Endpoint.

Deployment through the PowerShell
------------

```ps
## Global variables
$AzureRmSubscriptionName = "mvp-sub1"
$appAcronym="myapp1"
#Private Endpoints variables
$privateDnsZoneResourceGroupName = "infr-hub-prd-rg1"

###########################################################################################
#                                       ONLY FOR DEV                                      #
###########################################################################################
$env = "dev"
$RgName = "$env-myapp1-rg1"
$SharedRgName = "infra-noprd-shared-rg1"

#Private Endpoints variables
$existingVirtualNetworkResourceGroupName = "infr-hub-prd-rg1"
$existingVirtualNetworkName = "aadds-vnet"
$existingVirtualNetworkSubnetName = "endpoint-snet1"
###########################################################################################

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

###########################################################################################
#                 0. Backend : Shared Service Plan & Container Registry                   #
###########################################################################################

## Variable
$DeploymentName = "0.shared-plan"

## Action
Write-Host "Deploying : $DeploymentName in the resource group : $SharedRgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $SharedRgName `
  -TemplateFile .\$DeploymentName\mainTemplate.json `
  -env $env `
  -Confirm -ErrorAction Stop

Write-Host "Getting the  Deployment : $DeploymentName in the resource group : $SharedRgName" -ForegroundColor Cyan
$shared = Get-AzResourceGroupDeployment -ResourceGroupName $SharedRgName -Name $DeploymentName -ErrorAction Stop

###########################################################################################
#                   Application Insights, Azure Storage, Key Vault                        #
###########################################################################################

## Variable
$DeploymentName = "1.backend"

## Action
Write-Host "Deploying : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $RgName `
  -TemplateFile .\$DeploymentName\mainTemplate.json `
  -env $env -appAcronym $appAcronym `
  -Confirm -ErrorAction Stop

Write-Host "Getting the  Deployment : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
$backend = Get-AzResourceGroupDeployment -ResourceGroupName $RgName -Name $DeploymentName -ErrorAction Stop

<#
Some noise could be displayed, a improvment has been asked here
https://github.com/Azure/arm-template-whatif/issues/89
#>

# ###########################################################################################
#                                    User Interface                                       #
###########################################################################################

## Variable
$DeploymentName = "2.ui"
$additionalAppSettings =
@{ name = "APPINSIGHTS_INSTRUMENTATIONKEY"; value = $backend.Outputs["appinsightS_INSTRUMENTATIONKEY"].Value },
@{ name = "APPLICATIONINSIGHTS_CONNECTION_STRING"; value = $backend.Outputs["applicationinsightS_CONNECTION_STRING"].Value }

## Action
Write-Host "Deploying : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $RgName `
  -TemplateFile .\2.app-service\mainTemplate.json `
  -env $env -appKind "app" -appSuffix "$appAcronym-uiapp1" `
  -additionalAppSettings $additionalAppSettings `
  -Confirm -ErrorAction Stop

Write-Host "Getting the  Deployment : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
$ui = Get-AzResourceGroupDeployment -ResourceGroupName $RgName -Name $DeploymentName -ErrorAction Stop

###########################################################################################
#                                          API                                            #
###########################################################################################

## Variable
$DeploymentName = "3.api"
$allowedOrigins = @($ui.Outputs["defaultUrl"].Value)
$additionalAppSettings =
@{ name = "FunctionsUrl"; value = $function.Outputs["defaultUrl"].Value },
@{ name = "APPINSIGHTS_INSTRUMENTATIONKEY"; value = $backend.Outputs["appinsightS_INSTRUMENTATIONKEY"].Value },
@{ name = "APPLICATIONINSIGHTS_CONNECTION_STRING"; value = $backend.Outputs["applicationinsightS_CONNECTION_STRING"].Value }

## Action
Write-Host "Deploying : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $RgName `
  -TemplateFile .\2.app-service\mainTemplate.json `
  -env $env -appKind "app" -appSuffix "$appAcronym-apiapp1" `
  -additionalAppSettings $additionalAppSettings `
  -allowedOrigins $allowedOrigins `
  -Confirm -ErrorAction Stop  

Write-Host "Getting the  Deployment : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
$api = Get-AzResourceGroupDeployment -ResourceGroupName $RgName -Name $DeploymentName -ErrorAction Stop


###########################################################################################
#                                 Private Endpoint                                        #
###########################################################################################

## Variable
$DeploymentName = "3.private-endpoint"

$PrivateEndpoints = @(
  ($ui.Outputs["resourceID"].Value.Split("/")[-1], "$($ui.Outputs["resourceID"].Value.Split("/")[6])/$($ui.Outputs["resourceID"].Value.Split("/")[7])", "sites", "privatelink.azurewebsites.net"),
  ($function.Outputs["resourceID"].Value.Split("/")[-1], "$($function.Outputs["resourceID"].Value.Split("/")[6])/$($function.Outputs["resourceID"].Value.Split("/")[7])", "sites", "privatelink.azurewebsites.net")
)

foreach ($PrivateEndpoint in $PrivateEndpoints) {
  $existingResourceName = $PrivateEndpoint[0]
  $existingResourceType = $PrivateEndpoint[1]
  $groupId = $PrivateEndpoint[2]
  $privateDnsZoneName = $PrivateEndpoint[3]
  Write-Host "Dealing with private endpoint : $existingResourceName, type : $existingResourceType, groupId : $groupId, DNS zone RG : $privateDnsZoneResourceGroupName, Zone : $privateDnsZoneName" -ForegroundColor Cyan

  ## Action
  Write-Host "Deploying : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
  New-AzResourceGroupDeployment -Name "$($existingResourceName)-pe$($resourcePrivateEndpointIteration)" -ResourceGroupName $RgName `
    -TemplateFile .\$DeploymentName\mainTemplate.json `
    -existingResourceName $existingResourceName `
    -existingResourceType $existingResourceType `
    -groupIds @($groupId) `
    -existingVirtualNetworkResourceGroupName $existingVirtualNetworkResourceGroupName `
    -existingVirtualNetworkName $existingVirtualNetworkName `
    -existingVirtualNetworkSubnetName $existingVirtualNetworkSubnetName `
    -privateDnsZoneSubscriptionId $privateDnsZoneSubscriptionId `
    -privateDnsZoneResourceGroupName $privateDnsZoneResourceGroupName `
    -privateDnsZoneName $privateDnsZoneName `
    -Confirm -ErrorAction Stop
}


###########################################################################################
#                         WARNING - Used to clean the Resource Group                      #
###########################################################################################

## Variable
$emptyARMTemplate = @{ 
  '$schema'      = 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#' 
  contentVersion = '1.0.0.0' 
  resources      = @() 
}
  
## Action
Write-Host "Cleaning the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name "Cleaning" -ResourceGroupName $RgName `
  -TemplateObject $emptyARMTemplate `
  -Mode Complete `
  -Confirm -ErrorAction Stop 

```