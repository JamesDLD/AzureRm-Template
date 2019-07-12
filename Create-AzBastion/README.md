[Previous page >](../)

# Create an Azure Bastion host 

Prerequisite
-----
You should register to the preview to be able to create an Azure Bastion. Using PowerShell :
```
Login-AzAccount
Register-AzProviderFeature -FeatureName AllowBastionHost -ProviderNamespace Microsoft.Network
Register-AzResourceProvider -ProviderNamespace Microsoft.Network
```

Wait for few minutes then use the following cmdlet to ensure that you are registred :
```
Get-AzProviderFeature -ListAvailable
```

Usage
-----

Create an Azure Bastion host (Preview) - <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzBastion%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzBastion%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template creates an Azure Bastion host. For more information, see here: https://docs.microsoft.com/en-us/azure/bastion/bastion-create-host-portal