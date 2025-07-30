[Previous page >](../)

## Content

This template a workbook to list all ACR tokens and their expiration.

## Deployment through the Portal

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzWorkbookAcrTokens%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzWorkbookAcrTokens%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Deployment through the PowerShell

```ps
# Variables
$AzureRmSubscriptionName = "Azure subscription 1"
$RgName = "monResourceGroup"
$workbookDisplayName = "dmo acr tokens"
$workbookSourceId = "Azure Monitor"
$workbookType = "workbook"
$templateUri = "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzWorkbookAcrTokens/template.json"

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Action
Write-Host "Deploying : $workbookType-$workbookDisplayName in the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name $(("$workbookType-$workbookDisplayName").replace(' ', '')) -ResourceGroupName $RgName `
  -TemplateUri $TemplateUri `
  -workbookDisplayName $workbookDisplayName `
  -Confirm -ErrorAction Stop
```
