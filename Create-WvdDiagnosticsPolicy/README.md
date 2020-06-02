[Previous page >](../)

# Content
Demonstrate how to send the diagnostic settings of a Windows Virtual Desktop workspace to a Log Analytics workspace.

# PowerShell Deployment
```
New-AzPolicyDefinition -Name 'Windows Virtual Desktop Workspace Diagnostic Settings' `
  -DisplayName  'Deploy Diagnostic Settings for Windows Virtual Desktop Workspace to Log Analytics workspace' `
  -Policy "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/workspace.json" `
  -Parameter "https://raw.githubusercontent.com/JamesDLD/AzureRm-Template/master/Create-WvdDiagnosticsPolicy/parameters.json" `
  -Metadata '{"category":"Log Monitor"}' `
  -Mode Indexed

```