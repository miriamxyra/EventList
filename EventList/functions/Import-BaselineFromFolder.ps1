function Import-BaselineFromFolder {

<#
    .SYNOPSIS
    Imports one or multiple baselines from a folder into the database.

    .DESCRIPTION
    Imports one or multiple baselines from a folder into the database.

    .PARAMETER Path
    Path where the baseline(s) is/are located.

    .EXAMPLE
    Import-BaselineFromFolder -Path "C:\tmp\"

    Imports one or multiple baselines from "C:\tmp" into the database.

#>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $test = Get-ChildItem -LiteralPath $Path -Filter audit.csv -Recurse -ErrorAction SilentlyContinue -Force | Group-Object path

    foreach ($item in $test.Group) {
        if (![string]::IsNullOrEmpty($item.FullName)) {
            if ($item.Directory -match "GPO") {
                $gpReportXmlPathStr = $item.Directory -Replace("DomainSysvol\\GPO\\Machine\\microsoft\\windows nt\\Audit", "gpreport.xml")
                [xml]$xml = Get-Content -Path $gpReportXmlPathStr
                $auditPolicyNameStr = $xml.GPO.Name
                Import-BaselineIntoDb -Path $item.FullName -PolicyName $auditPolicyNameStr
            }
        }
    }
}