[Previous page >](../)

Content
------------
ARM Template that create [Azure Private Endpoint](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview).
Note: this template doesn't create the DNS record to access the PaaS Service through private endpoints, please refer to the following [guide](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#dns-configuration) to create the correct DNS record.

Comments:
- Note 1: The Private Endpoint should be in the same region and subscription of its Virtual Network.
- Note 2: The Private Endpoint could be in a different resource group than its Virtual Network.
- Note 3: Only one group Id per Private Endpoint is permitted when connecting to a first-party resource.

Deployment through the Portal
------------

Create an Azure Private Endpoint - <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzPrivateEnpoints%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzPrivateEnpoints%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


Deployment through the PowerShell
------------

```ps

#Variable
$azureRmSubscriptionName="Your Azure Subscrition Name"
$tags = "{""env"":""dev"",""project"":""demo"",""project_owner"":""james@dld23.com""}""" 
$existingVirtualNetworkResourceGroupName="The Vnet Rg Name" #Set it to null if it's the same than the Private Endpoint
$existingVirtualNetworkName="The Vnet Name"
$existingVirtualNetworkSubnetName="The Subnet Name"
$existingResourceSubscriptionId="null" #Set it to null or do not call it from the template if the resource is in the same subscription that your private endpoint
$existingResourceResourceGroupName="The Private Endpoint Rg Name"
$existingResourceName="The Resource name to link to the private Endpoint"
$existingResourceType="Microsoft.Sql/servers" #Resource Type including resource provider namespace of the Resource that will be linked to the Private Endpoint
$groupId="sqlServer" #The ID of the group obtained from the remote resource that this private endpoint should connect to
$resourcePrivateEndpointIteration="1" #Stands for the first private endpoint of your resource, a resource can have several private endpoints.


#Authentication
Connect-AzAccount
$AzureRmContext = Get-AzSubscription -SubscriptionName $azureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $azureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

#ARM Deployment
New-AzResourceGroupDeployment -Name "private-endpoint-$($existingResourceName)-pe$($resourcePrivateEndpointIteration)" -ResourceGroupName $existingResourceResourceGroupName `
    -TemplateUri https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzPrivateEnpoints/azuredeploy.json `
    -tags $tags `
    -existingVirtualNetworkResourceGroupName $existingVirtualNetworkResourceGroupName `
    -existingVirtualNetworkName $existingVirtualNetworkName `
    -existingVirtualNetworkSubnetName $existingVirtualNetworkSubnetName `
    -existingResourceSubscriptionId $existingResourceSubscriptionId `
    -existingResourceResourceGroupName $existingResourceResourceGroupName `
    -existingResourceName $existingResourceName `
    -existingResourceType $existingResourceType `
    -groupIds @($groupId) `
    -resourcePrivateEndpointIteration $resourcePrivateEndpointIteration -ErrorAction Stop

```