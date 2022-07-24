[Previous page >](../)

Content
------------
Content of this template is explained in the following article [An Azure notification API for Slack, Office 365 and more…](https://medium.com/@jamesdld23/an-azure-notification-api-for-slack-office-365-and-more-f14b7bd7af35).


Deployment through the Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzNotificationApi%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzNotificationApi%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


Deployment through the PowerShell
------------

```ps
# Variables
$AzureRmSubscriptionName = "mvp-sub1"
$RgName = "infr-hub-prd-rg1"
$templateUri = "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzNotificationApi/template.json"

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Action
Write-Host "Deploying to the resource group : $RgName an Azure Logic App for slack and Office 365 notifications" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name "NotificationApi" -ResourceGroupName $RgName `
  -TemplateUri $TemplateUri `
  -Confirm -ErrorAction Stop

```