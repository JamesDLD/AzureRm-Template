[Previous page >](../)

# Content
Demonstrate how to send the diagnostic settings of Windows Virtual Desktop resources to a Log Analytics workspace.
Used among this [article](https://medium.com/faun/diagnostic-settings-for-azure-windows-virtual-desktop-resources-part-2-4bfb9ce8d1be).

# Policy Creation
```
# Login first with Connect-AzAccount if not using Cloud Shell

# Create the Policy Definition for the Windows Virtual Desktop Workspaces
New-AzPolicyDefinition -Name 'Windows Virtual Desktop Workspaces Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Workspaces to Log Analytics workspace' `
  -Policy "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/workspaces.json" `
  -Parameter "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/parameters.json" `
  -Metadata '{"category":"Log Monitor"}' `
  -Mode Indexed

# Create the Policy Definition for the Windows Virtual Desktop Host Pools
New-AzPolicyDefinition -Name 'Windows Virtual Desktop Host Pools Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Host Pools to Log Analytics workspace' `
  -Policy "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/hostpools.json" `
  -Parameter "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/parameters.json" `
  -Metadata '{"category":"Log Monitor"}' `
  -Mode Indexed

# Create the Policy Definition for the Windows Virtual Desktop Application Groups
New-AzPolicyDefinition -Name 'Windows Virtual Desktop Application Groups Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Application Groups to Log Analytics workspace' `
  -Policy "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/applicationgroups.json" `
  -Parameter "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/parameters.json" `
  -Metadata '{"category":"Log Monitor"}' `
  -Mode Indexed

```

# Policy Initiative Creation
```
# Login first with Connect-AzAccount if not using Cloud Shell

# Variable
$parameters = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/parameters.json"

## Create the Policy Definition for the Windows Virtual Desktop Workspaces
$workspacesPolicy = New-AzPolicyDefinition -Name 'Windows Virtual Desktop Workspaces Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Workspaces to Log Analytics workspace' `
  -Policy "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/workspaces.json" `
  -Parameter ($parameters | ConvertTo-Json) `
  -Metadata '{"category":"Log Monitor"}' `
  -Mode Indexed

## Create the Policy Definition for the Windows Virtual Desktop Host Pools
$hostpoolsPolicy = New-AzPolicyDefinition -Name 'Windows Virtual Desktop Host Pools Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Host Pools to Log Analytics workspace' `
  -Policy "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/hostpools.json" `
  -Parameter ($parameters | ConvertTo-Json) `
  -Metadata '{"category":"Log Monitor"}' `
  -Mode Indexed

## Create the Policy Definition for the Windows Virtual Desktop Application Groups
$applicationgroupsPolicy = New-AzPolicyDefinition -Name 'Windows Virtual Desktop Application Groups Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Application Groups to Log Analytics workspace' `
  -Policy "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/applicationgroups.json" `
  -Parameter ($parameters | ConvertTo-Json) `
  -Metadata '{"category":"Log Monitor"}' `
  -Mode Indexed

## Prepare the Policy Definition variable for the Policy Initiative
$params = @{ 
  effect = @{ value = "[parameters('effect')]" };
  profileName = @{ value = "[parameters('profileName')]" };
  logAnalytics = @{ value = "[parameters('logAnalytics')]" };
  logsEnabled = @{ value = "[parameters('logsEnabled')]" }
}

$PolicyDefinitions = @(
  @{
    policyDefinitionId = $workspacesPolicy.PolicyDefinitionId
    parameters = $params
  };
  @{
    policyDefinitionId = $hostpoolsPolicy.PolicyDefinitionId
    parameters = $params
  };
  @{
    policyDefinitionId = $applicationgroupsPolicy.PolicyDefinitionId
    parameters = $params
  }
)

## Create the Policy Iniative for the Windows Virtual Desktop Resources
New-AzPolicySetDefinition -Name 'Windows Virtual Desktop Resources Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Resources to Log Analytics workspace' `
  -PolicyDefinition ($PolicyDefinitions | ConvertTo-Json -Depth 3) `
  -Parameter ($parameters | ConvertTo-Json) `
  -Metadata '{"category":"Log Monitor"}'

```

# Policy Initiative Assignment
```
# Login first with Connect-AzAccount if not using Cloud Shell

## Variable
$scope = Get-AzResourceGroup -Name "jdld-we-demo-wvd-rg1" #Replace it with your target scope
$logAnalytics = Get-AzOperationalInsightsWorkspace -Name "jdld-we-demo-wvd-wu2-logaw1" -ResourceGroupName "jdld-we-demo-wvd-rg1" #Replace it with your target Log Analytics Workspace
$roleDefinitionId = (Get-AzRoleDefinition -Name "Contributor").Id #For the Demo we will assing the "Contributor" privilege to our Policy Assignment Managed Identity
$initiativePolicy = Get-AzPolicySetDefinition -Name 'Windows Virtual Desktop Resources Diagnostic Settings' 
$params = @{'logAnalytics'=($logAnalytics.ResourceId)}

## Assign the Initiative Policy
New-AzPolicyAssignment -Name 'WVD to Log Analytics Demo' `
  -DisplayName 'WVD to Log Analytics Demo' `
  -PolicySetDefinition $initiativePolicy `
  -Scope $scope.ResourceId `
  -AssignIdentity `
  -Location 'westeurope' `
  -PolicyParameterObject $params

## Get the newly created policy assignment object
$PolicyAssignment = Get-AzPolicyAssignment -Name 'WVD to Log Analytics Demo' -Scope $scope.ResourceId

## Extract the ObjectID of the Policy Assignment Managed Identity
$objectID = [GUID]($PolicyAssignment.Identity.principalId)

## Create a role assignment from the previous information
New-AzRoleAssignment -Scope $scope.ResourceId -ObjectId $objectID -RoleDefinitionId $roleDefinitionId

```