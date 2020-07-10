[Previous page >](../)

Content
------------
This template creates an [Azure Private Endpoint](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) based on your Network Topology, you can also use it to create the associated DNS private record.

- Your can refer to the following article for more information : [Network Topologies for Azure Private Endpoints](https://medium.com/faun/network-topologies-for-azure-private-endpoints-ed7c968b0acd).

- The following [guide](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration) reminds the recommended DNS zone names to use with Private Endpoints.

> **Comments:**
> - Note 1: The Private Endpoint should be in the same region and subscription than its Virtual Network.
> - Note 2: The Private Endpoint could be in a different resource group than its Virtual Network.
> - Note 3: Only one group Id per Private Endpoint is permitted when connecting to a third-party resource.

Deployment through the Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzPrivateEnpoints%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzPrivateEnpoints%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


Deployment through the PowerShell
------------

```ps

## Variable
$AzureRmSubscriptionName = "mvp-sub1"
$RgName = "dld-corp-mvp-dataplatform"

$existingResourceName = "dldcorpmvpadls"
$existingResourceType = "Microsoft.Storage/storageAccounts"
$groupId = "blob"
$resourcePrivateEndpointIteration = "1"
$DeploymentName = "$($existingResourceName)-pe$($resourcePrivateEndpointIteration)"

$existingVirtualNetworkResourceGroupName = "jdld-we-demo-wvd-rg1"
$existingVirtualNetworkName = "jdld-we-demo-wvd-vnet1"
$existingVirtualNetworkSubnetName = "endpoint-snet1"

$privateDnsZoneResourceGroupName = "infr-hub-prd-rg1"
$privateDnsZoneName = "privatelink.blob.core.windows.net"

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Action
Write-Host "Deploying : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name "$($existingResourceName)-pe$($resourcePrivateEndpointIteration)" -ResourceGroupName $RgName `
  -TemplateUri https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzPrivateEnpoints/template.json `
  -existingResourceName $existingResourceName `
  -groupIds @($groupId) `
  -resourcePrivateEndpointIteration $resourcePrivateEndpointIteration `
  -existingResourceType $existingResourceType `
  -existingVirtualNetworkResourceGroupName $existingVirtualNetworkResourceGroupName `
  -existingVirtualNetworkName $existingVirtualNetworkName `
  -existingVirtualNetworkSubnetName $existingVirtualNetworkSubnetName `
  -privateDnsZoneResourceGroupName $privateDnsZoneResourceGroupName `
  -privateDnsZoneName $privateDnsZoneName `
  -Confirm -ErrorAction Stop

```