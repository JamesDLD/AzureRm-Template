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
$AzureRmSubscriptionName = "my-subsctiption-name"
$RgName = "my-workbook-rg-name"
$workbookDisplayName = "NetworkDebug"
$workbookSourceId = "Azure Monitor"
$workbookType = "workbook"

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Action
Write-Host "Deploying : $DeploymentName in the resource group : $RgName" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name $workbookDisplayName -ResourceGroupName $RgName `
  -TemplateUri https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzWorkbookNetwork/template.json `
  -workbookDisplayName $workbookDisplayName `
  -workbookType $workbookType `
  -workbookSourceId $workbookSourceId `
  -Confirm -ErrorAction Stop

```