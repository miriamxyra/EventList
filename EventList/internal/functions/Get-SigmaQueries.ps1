function Get-SigmaQueries {

<#
    .SYNOPSIS
    Returns the queries for the desired target system.

    .DESCRIPTION
    Returns the queries for the desired target system. Either as YAML, sigma command or already converted by sigma.

    .PARAMETER OutputPath
    Defines where the Output should be stored.

    .PARAMETER siemName
    Defines the target SIEM system. Must be supported by Sigma.

    .PARAMETER yamlOnly
    If set, the configuration will be generated in YAML only

    .EXAMPLE
    Get-SigmaQueries -OutputPath $ExportFolder -siemName $SelectedComboSiemBox

    Returns the queries for the desired target system.

#>

    param (
        [string]$OutputPath,
        [string]$siemName,
        [switch]$yamlOnly
    )

    $query = "select target from sigma_supportedSiem where name = '" + $siemName + "' COLLATE NOCASE;"
    $target = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty target

    $queryObj = Get-Queries

    $tmp = get-date -f yyyyMMddHHmmss

    $yamlPath = $OutputPath + "\" + $tmp + "_EventList-Queries\yaml\"
    New-Item -ItemType directory -Path $OutputPath\$tmp"_EventList-Queries"
    New-Item -ItemType directory -Path $yamlPath

    foreach ($item in $queryObj) {
        $addQuery = $false
        $tmpStr = ""
        $sigmaLocation = Get-SigmaPath
        if ($sigmaLocation) {
            $sigmaIsInstalled = $true
        }
        else {
            $sigmaIsInstalled = $false
        }

        $area_name = ConvertFrom-PSSQLString -Text $item.area_name
        $technique_id = ConvertFrom-PSSQLString -Text $item.technique_id
        $technique_name = ConvertFrom-PSSQLString -Text $item.technique_name
        $title = ConvertFrom-PSSQLString -Text $item.title
        $description = ConvertFrom-PSSQLString -Text $item.description
        $status = ConvertFrom-PSSQLString -Text $item.status
        $date = ConvertFrom-PSSQLString -Text $item.date
        $author = ConvertFrom-PSSQLString -Text $item.author
        $raw_yaml = ConvertFrom-PSSQLString -Text $item.raw_yaml
        $level = ConvertFrom-PSSQLString -Text $item.level
        $filename = ConvertFrom-PSSQLString -Text $item.filename

        $yamlFile = ".\yaml\" + $filename
        Set-Content -Path ($yamlPath + $filename) -Value $raw_yaml



        if ($old_areaName -ne $area_name) {
            if ($old_areaName){
                $tmpStr = $tmpStr + "`r`n"
            }

            $tmpStr = $tmpStr + "# " + $area_name + "`r`n"
        }

        if ($old_techniqueName -ne $technique_name) {
            $tmpStr = $tmpStr + "`r`n"
            $tmpStr = $tmpStr + "## " + $technique_id + " " + $technique_name + "`r`n"
        }

        $tmpStr = $tmpStr + "`r`n"
        $tmpStr = $tmpStr + "### " + $title + "`r`n"

        if ($sigmaIsInstalled) {
            "Processing " + $title + "`r`n" >> $OutputPath\$tmp"_EventList-Queries\SigmaLog.txt"
        }

        $tmpStr = $tmpStr + "* Author: " + $author + "`r`n"
        $tmpStr = $tmpStr + "* Date: " + $date + "`r`n"
        $tmpStr = $tmpStr + "* Query Status: " + $status + "`r`n"
        $tmpStr = $tmpStr + "* Level: " + $level + "`r`n"

        $tmpStr = $tmpStr + "*" + $description + "*`r`n"

        if ($yamlOnly) {
            $tmpStr = $tmpStr + "#### Yaml:`r`n"
            $tmpStr = $tmpStr + $raw_yaml
            $addQuery = $true
        }
        else {
            if ($sigmaIsInstalled) {
                $sigmaquery = python.exe $sigmaLocation -t $target ($yamlPath + $filename) 2>>$OutputPath\$tmp"_EventList-Queries\SigmaLog.txt"
                if ($sigmaquery) {
                    $addQuery = $true
                }

                $tmpStr = $tmpStr + "    " + $sigmaquery + "`r`n"
                if ($addQuery) {
                    $scriptStr = $scriptStr + $sigmaquery + "`r`n`r`n"
                }
            }
            else {
                $tmpStr = $tmpStr + "    python.exe tools/sigmac -t $target $yamlFile `r`n"
                $addQuery = $true
                $scriptStr = $scriptStr + "python.exe tools/sigmac -t $target $yamlFile `r`n`r`n"
            }
        }

        if ($addQuery) {
            $outputStr = $outputStr + $tmpStr
        }

        $old_areaName = $area_name
        $old_techniqueName = $technique_name
    }

    Set-Content -Path $OutputPath\$tmp"_EventList-Queries\EventList-Queries.md" -Value $outputStr

    if ($scriptStr) {
        Set-Content -Path $OutputPath\$tmp"_EventList-Queries\EventList-Queries.txt" -Value $scriptStr
    }

}