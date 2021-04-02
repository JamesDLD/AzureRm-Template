[Previous page >](../)

Content
------------
Content of this template is explained in the following article [Automation to block malicious flows detected by Azure Traffic Analytics](https://medium.com/microsoftazure/automation-to-block-malicious-flows-detected-by-azure-traffic-analytics-b010298ba347).


With Azure [Traffic Analytics](https://docs.microsoft.com/en-us/azure/network-watcher/traffic-analytics?WT.mc_id=AZ-MVP-5003548) on Network Security Groups (NSG) we can visualize precious insights like allowed and denied flows per flow type.

This template will create resources to block [Malicious](https://docs.microsoft.com/en-us/azure/network-watcher/traffic-analytics-schema?WT.mc_id=AZ-MVP-5003548&WT.mc_id=AZ-MVP-5003548#notes) flows type that are allowed on our NSG and we will automatically block them with a Network Security Group rule.


Deployment through the Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FBlock-AzMaliciousFlow%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FBlock-AzMaliciousFlow%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


Deployment through the PowerShell
------------

```ps
# Variables
$AzureRmSubscriptionName = "mvp-sub1"
$RgName = "infr-hub-prd-rg1"
$sendEmailTo = "your-email1@company.fr;your-email2@company.fr"
$logAnalytics = "/subscriptions/<your sub id>/resourcegroups/<the RG name of the Log Analytics Workspace>/providers/microsoft.operationalinsights/workspaces/<The Log Analytics Workspace name containing Traffic Analytics Logs>"
$templateUri = "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Block-AzMaliciousFlow/template.json"

## Connectivity
# Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Action
Write-Host "Deploying to the resource group : $RgName an Azure Logic App that will deny malicious flows" -ForegroundColor Cyan
New-AzResourceGroupDeployment -Name "Block-MaliciousFlow" -ResourceGroupName $RgName `
  -TemplateUri $TemplateUri `
  -sendEmailTo $sendEmailTo `
  -logAnalytics $logAnalytics `
  -Confirm -ErrorAction Stop

```