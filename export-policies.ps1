Param($TenantId, $Location)

(Get-Content ./assets/mg-structure.json) -replace '""', "`"$tenantId`"" | Set-Content ./assets/mg-structure.json

./assets/deploy-ManagementGroupStructure.ps1 -TenantId $TenantId -Location $Location

$gs = @"
{
    "pacOwnerId": "4f5222f0-6677-4987-8de6-6fbc97ab631f",
    "pacEnvironments": [
        {
            "pacSelector": "amba",
            "cloud": "AzureCloud",
            "tenantId": "$tenantId",
            "deploymentRootScope": "/providers/Microsoft.Management/managementGroups/amba",
            "globalNotScopes":[],
            "desiredState": {
                "strategy": "full",
                "keepDfcSecurityAssignments": false
            },
            "managedIdentityLocation": "$Location"
        }
    ]
}
"@

$gs | Out-File ./Definitions/global-settings.jsonc -Verbose

git clone https://github.com/Azure/azure-monitor-baseline-alerts.git tmp

Copy-Item "./tmp/patterns/alz/scripts/Old scripts/Start-AMBACleanup.ps1" ./assets/Start-AMBACleanup.ps1 -Verbose

$pseudoRootManagementGroup = "amba"

# Deploy AMBA 
New-AzManagementGroupDeployment -ManagementGroupId $pseudoRootManagementGroup `
    -Location $location `
    -TemplateUri "https://raw.githubusercontent.com/Azure/azure-monitor-baseline-alerts/main/patterns/alz/alzArm.json" `
    -TemplateParameterFile ".\assets\alzArm.param.json" `
    -Verbose

Start-Sleep -Seconds 180

Remove-Item -Path tmp -Recurse -Force

Export-AzPolicyResources -DefinitionsRootFolder ./Definitions -OutputFolder ./Output

# Remove the folders first:

Remove-Item -Path ./Definitions/policyDefinitions -Recurse -Force
Remove-Item -Path ./Definitions/policySetDefinitions -Recurse -Force
Remove-Item -Path ./Definitions/policyAssignments -Recurse -Force

# Copy new files:

Copy-Item ./Output/export/Definitions/policyDefinitions ./Definitions -Force -Recurse
Copy-Item ./Output/export/Definitions/policySetDefinitions ./Definitions -Force -Recurse
Copy-Item ./Output/export/Definitions/policyAssignments ./Definitions -Force -Recurse

Remove-Item -Path Output -Recurse -Force

Remove-Item -Path ./Definitions/global-settings.jsonc -Force

# Remove managed identity parts

# Fix missing displaynames in the policy set definitions

./assets/Start-AMBACleanup.ps1 -pseudoRootManagementGroup $pseudoRootManagementGroup -Confirm:$false

Remove-Item -Path ./assets/Start-AMBACleanup.ps1 -Force





