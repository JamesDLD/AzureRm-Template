[Previous page >](../)

Content
------------
This template creates an [Azure Monitor Workbook](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/workbooks-overview?WT.mc_id=AZ-MVP-5003548) that gives Insights from your [Network Security Group (NSG) flow logs](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview?WT.mc_id=AZ-MVP-5003548).

- Your can refer to the following article for more information : [An Azure Monitor Workbook for NSG flow logs](https://medium.com/@jamesdld23/an-azure-monitor-workbook-for-nsg-flow-logs-43e11e82d89c?WT.mc_id=AZ-MVP-5003548).


Deployment through the Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzWorkbookNetwork%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzWorkbookNetwork%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


Deployment through the PowerShell
------------

```ps
# Variables
$AzureRmSubscriptionName = "mvp-sub1"
$RgName = "infr-hub-prd-rg1"
$workbookDisplayName = "Network Debug2" #"Azure Inventory" #"NetworkDebug"
$workbookSourceId = "Azure Monitor"
$workbookType = "workbook"
$templateUri = "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzWorkbookNetwork/template.json"
$workbookSerializedData = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzWorkbookNetwork/galleryTemplate.json"

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Action
Write-Host "Deploying : $workbookType-$workbookDisplayName in the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name $(("$workbookType-$workbookDisplayName").replace(' ', '')) -ResourceGroupName $RgName `
  -TemplateUri $TemplateUri `
  -workbookDisplayName $workbookDisplayName `
  -workbookType $workbookType `
  -workbookSourceId $workbookSourceId `
  -workbookSerializedData ($workbookSerializedData | ConvertTo-Json -Depth 20) `
  -Confirm -ErrorAction Stop

```