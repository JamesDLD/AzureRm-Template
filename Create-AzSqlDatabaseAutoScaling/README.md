[Previous page >](../)

Content
------------
Full details of this ARM Template are available in the following article [An Azure Logic Apps to automate Azure SQL Databases scaling](https://medium.com/@jamesdld23/auto-scale-azure-sql-databases-with-azure-logic-apps-feeaeaf1e376).


Deployment through the Portal
------------

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzSqlDatabaseAutoScaling%2Ftemplate.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FCreate-AzSqlDatabaseAutoScaling%2Ftemplate.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


Deployment through PowerShell
------------

```ps
# Variables
$AzureRmSubscriptionName = "<yoursubid>"
$RgName = "<rgname>"
$UserAssignedIdentityName = "<identityname>"
$SqlServerId = "/subscriptions/xxxxxxx-xxxxxxx-xxxxxxx-xxxxxxx-xxxxxxx/resourceGroups/rgname/providers/Microsoft.Sql/servers/yourserver"
$templateUri = "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-AzSqlDatabaseAutoScaling/template.json"

# Action
## Login first with Connect-AzAccount if not using Cloud Shell
$AzureRmContext = Get-AzSubscription -SubscriptionName $AzureRmSubscriptionName | Set-AzContext -ErrorAction Stop
Select-AzSubscription -Name $AzureRmSubscriptionName -Context $AzureRmContext -Force -ErrorAction Stop

## Create a user-assigned managed identity, for more information on this procedure you chec have a look on the following [reference](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-powershell&WT.mc_id=DOP-MVP-5003548#create-a-user-assigned-managed-identity-2).
$UserAssignedIdentity = New-AzUserAssignedIdentity -ResourceGroupName $RgName -Name $UserAssignedIdentityName

## Assign the role to the managed identity, for more information on this procedure you chec have a look on the following [reference](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-powershell?WT.mc_id=AZ-MVP-5003548#step-4-assign-role).
New-AzRoleAssignment -ObjectId $UserAssignedIdentity.PrincipalId -RoleDefinitionName "SQL DB Contributor" -Scope $SqlServerId

## Deploy Azure Logic Apps
Write-Host "Deploying to the resource group : $RgName Azure Logic Apps that will scale SQL Databases" -ForegroundColor Cyan

$parameters = @{
    tags = @{
        role = 'Scale down Azure SQL Databases'
    }
    userAssignedIdentityId = $UserAssignedIdentity.Id
    logicAppName = 'demo-scale-down-sql-logic'
    sqlServerId = $SqlServerId
    desiredSkusPerDatabases = @{
        target = @(
        @{
            name = "DEMO1"
            sku = @{
                capacity = 5
                name = "Basic"
                tier = "Basic"
            }
        }
        @{
            name = "DEMO2"
            sku = @{
                capacity = 5
                name = "Basic"
                tier = "Basic"
            }
        }
        )
    }
    recurrence = @{
        frequency = "Week"
        interval = 1
        schedule = @{
            hours = @("20")
            minutes = @(0)
            weekDays = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
        }
        timeZone = "Romance Standard Time"
    }
}

New-AzResourceGroupDeployment -Name "SqlDatabasesScaleDown" -ResourceGroupName $RgName `
  -TemplateFile ./template.json `
  -TemplateParameterObject $parameters

$parameters = @{
    tags = @{
        role = 'Scale up Azure SQL Databases'
    }
    userAssignedIdentityId = $UserAssignedIdentity.Id
    logicAppName = 'demo-scale-up-sql-logic'
    sqlServerId = $SqlServerId
    desiredSkusPerDatabases = @{
        target = @(
        @{
            name = "DEMO1"
            sku = @{
                capacity = 20
                name = "Standard"
                tier = "Standard"
            }
        }
        @{
            name = "DEMO2"
            sku = @{
                capacity = 20
                name = "Standard"
                tier = "Standard"
            }
        }
        )
    }
    recurrence = @{
        frequency = "Week"
        interval = 1
        schedule = @{
            hours = @("8")
            minutes = @(0)
            weekDays = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
        }
        timeZone = "Romance Standard Time"
    }
}

New-AzResourceGroupDeployment -Name "SqlDatabasesScaleUp" -ResourceGroupName $RgName `
  -TemplateFile ./template.json `
  -TemplateParameterObject $parameters

```