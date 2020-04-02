# Content
Contain a script sample that demonstrates on how to use [User-defined functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-user-defined-functions) in Azure Resource Manager template.

This is part a Medium article published [here](https://medium.com/@jamesdld23/a-user-defined-function-in-azure-resource-manager-template-dbba3d834c8b).

# Call Sample
```
#Variable
$SubId="Your Azure Subsciption Id"
$DeploymentName="GetVnetObject"
$RgName="The Resource Group Name Containing Your Vnet"
$VnetName="Your Vnet name"


#ARM Deployment
New-AzResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $RgName `
-TemplateFile .\mainTemplate.json `
-existingVirtualNetworkSubscriptionId $SubId `
-existingVirtualNetworkResourceGroupName $RgName `
-existingVirtualNetworkName $VnetName
```