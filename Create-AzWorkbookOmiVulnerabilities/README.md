[Previous page >](../)

Related blog post
------------
[Azure Monitor - OMI Vulnerabilities Rapid Check Workbook](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/azure-monitor-omi-vulnerabilities-rapid-check-workbook/ba-p/2779755?WT.mc_id=AZ-MVP-5003548).


Deployment using the Azure Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzWorkbookOmiVulnerabilities%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


Deployment using PowerShell
------------

```ps
# Variables
$AzureRmSubscriptionName = "mvp-sub1"
$RgName = "infr-hub-prd-rg1"
$workbookDisplayName = "OMI Vulnerabilities - Rapid Check"
$workbookSourceId = "Azure Monitor"
$workbookType = "workbook"
$templateUri = "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzWorkbookOmiVulnerabilities/template.json"
$workbookSerializedData = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzWorkbookOmiVulnerabilities/galleryTemplate.json"

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