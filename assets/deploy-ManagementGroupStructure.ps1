Param($TenantId, $Location)

function ConvertPSObjectToHashtable {
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
            )

            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject]) {
            $hash = @{}

            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
            }

            $hash
        }
        else {
            $InputObject
        }
    }
}

$v = Get-Content ./assets/mg-structure.json | ConvertFrom-Json

foreach ($tlManagementGroup in $v.($TenantId)) {
    New-AzDeployment -Location $Location -TemplateFile ./assets/mg.bicep -Id $tlManagementGroup.id -DisplayName $tlManagementGroup.displayName -parent $TenantId -Verbose
    if ($null -ne $tlManagementGroup.children) {
        foreach ($tlChild in $tlManagementGroup.children) {
            New-AzDeployment -Location $Location -TemplateFile ./assets/mg.bicep -Id $tlChild.id -DisplayName $tlChild.displayName -parent $tlManagementGroup.id -Verbose
            if ($null -ne $tlChild.children) {
                foreach ($tlSubChild in $tlChild.children) {
                    New-AzDeployment -Location $Location -TemplateFile ./assets/mg.bicep -Id $tlSubChild.id -DisplayName $tlSubChild.displayName -parent $tlChild.id -Verbose
                    if ($null -ne $tlSubChild.subscriptions) {
                        $tlSubchild.subscriptions | Foreach-Object {
                            New-AzDeployment -templatefile ./assets/sub.bicep -Location $Location -subscriptionId $_ -parent $tlSubChild.id -Verbose
                        }
                    }
                }
            }
        }
    }
}