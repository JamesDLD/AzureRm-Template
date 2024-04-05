[Previous page >](../)

Content
------------
Complete details of this template are available in the following article [An Azure Logic Apps to automate Azure SQL Databases scaling](https://medium.com/@jamesdld23/xxxxxx).


Deployment through the Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzSqlDatabaseAutoScaling%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzSqlDatabaseAutoScaling%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


Deployment through the PowerShell
------------

```ps
# Variables
$AzureRmSubscriptionName = "mvp-sub1"
$RgName = "infr-jdld-noprd-rg1"
$UserAssignedIdentityName = "demo-sql-scaling-id"
$SqlServerId = "/subscriptions/6094e15e-3e04-47b5-9b3b-aa8ae3cf1e52/resourceGroups/infr-hub-prd-rg2/providers/Microsoft.Sql/servers/demosqlautoscaling"
$templateUri = "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzSqlDatabaseAutoScaling/template.json"

# Action
## Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Create a user-assigned managed identity, for more information on this procedure you chec have a look on the following [reference](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-powershell&WT.mc_id=DOP-MVP-5003548#create-a-user-assigned-managed-identity-2).
$UserAssignedIdentity = New-AzUserAssignedIdentity -ResourceGroupName $RgName -Name $UserAssignedIdentityName

## Assign the role to the managed identity, for more information on this procedure you chec have a look on the following [reference](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-powershell?WT.mc_id=AZ-MVP-5003548#step-4-assign-role).
New-AzRoleAssignment -ObjectId $UserAssignedIdentity.PrincipalId -RoleDefinitionName "SQL Server Contributor" -Scope $SqlServerId

Write-Host "Deploying to the resource group : $RgName an Azure Logic App that will scale SQL Databasesss" -ForegroundColor Cyan

$parameters = @{
    tags = @{
        role = 'Auto scaling of Azure SQL Databases'
    }
    userAssignedIdentityId = $UserAssignedIdentity.Id
    logicAppName   = 'demologic01'
    sqlServerId  = $SqlServerId
    desiredSkusPerDatabases = @{
        target = @(
           @{
               name = "DEMO"
               sku = @{
                   capacity = 5
                   name = "Basic"
                   tier = "Basic"
               }
           }
        )
    }
}

New-AzResourceGroupDeployment -whatif -Name "SqlDatabaseAutoScaling" -ResourceGroupName $RgName `
  -TemplateFile ./template.json `
  -TemplateParameterObject $parameters

New-AzResourceGroupDeployment -Name "SqlDatabaseAutoScaling" -ResourceGroupName $RgName `
  -TemplateFile ./template.json `
  -TemplateParameterObject $parameters `
  -Confirm -ErrorAction Stop
```