# Content
Demonstrate how to send the diagnostic settings of a Windows Virtual Desktop workspace to a Log Analytics workspace.

# UI Deployment
Click the button below to deploy:

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FDeploy-WvdWorkspaceDiagnostics%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FJamesDLD%2FAzureRm-Template%2Fmaster%2FDeploy-WvdWorkspaceDiagnostics%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

# PowerShell Deployment
```
#Variable
$DeploymentName="WVD-Workspace-DiagnosticsSettings"
$RgName="jdld-we-demo-wvd-rg1"

New-AzResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $RgName `
  -TemplateFile .\template.json `
  -TemplateParameterFile .\parameters.json

```