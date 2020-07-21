[Previous page >](../)

# Content
Contain a script sample that demonstrates how to create Resource Group.

# Call Sample
```
## Global Variable
$AzureRmSubscriptionName = "mvp-sub1"

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

###########################################################################################
#                                 Method 1 : Input variables                              #
###########################################################################################
## Variable
$productName = "sap"
$context = "app"
$envs = @("dev", "int")

## VM Creation
New-AzSubscriptionDeployment `
  -TemplateFile .\template.json `
  -Name $productName -Location francecentral `
  -productName $productName `
  -context $context `
  -envs $envs `
  -confirm

###########################################################################################
#                          Method 2 : variables within a file                             #
###########################################################################################
New-AzSubscriptionDeployment `
  -TemplateFile .\template.json `
  -Name $productName -Location francecentral `
  -TemplateParameterFile .\parameters.json `
  -confirm

```

Deployment through the Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzRg%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzRg%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>
