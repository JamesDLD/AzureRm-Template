[Previous page >](../)

# Content
Demonstrate how to send the diagnostic settings of Windows Virtual Desktop resources to a Log Analytics workspace.

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