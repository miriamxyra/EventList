function Get-SigmaQueries {

    <#
    .SYNOPSIS
    Returns the queries for the desired target system.

    .DESCRIPTION
    Returns the queries for the desired target system. Either as YAML, sigma command or already converted by sigma.

    .PARAMETER Path
    Defines where the Output should be stored.

    .PARAMETER siemName
    Defines the target SIEM system. Must be supported by Sigma.

    .PARAMETER yamlOnly
    If set, the configuration will be generated in YAML only

    .EXAMPLE
    Get-SigmaQueries -Path $ExportFolder -siemName $SelectedComboSiemBox

    Returns the queries for the desired target system.

#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]

    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('TechniqueId', 'BaselineName')]
        [string]$Identity,
        [Parameter(Mandatory = $True)]
        [string]$Path,
        [Parameter(Mandatory = $True)]
        [string]$siemName,
        [switch]$yamlOnly
    )

    process {

        $query = "select target from sigma_supportedSiem where name = '" + $siemName + "' COLLATE NOCASE;"
        $target = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty target

        if ($Script:openFromGui) {
            $MitreTechniques = Get-CheckedMitreTechniques
            $MitreAreas = Get-CheckedMitreAreas
        }
        else {   
            if ($identity) {
                if (Get-BaselineNameFromDB -BaselineName $Identity) {
                    $MitreTechniques = Get-MitreTechniquesFromBaseline -BaselineName $Identity
                }
                elseif ($Identity -match "^T\d{4}$") {
                    $MitreTechniques = $("'" + $Identity + "'")
                }
                elseif ( ($Identity -match "^['T\d{4}$]") -or ($Identity -match "^T\d{4}$") ) {
                    $MitreTechniques = $Identity
                }
            }


            if ($MitreTechniques) {
                $tmpStr = $tmpStr + " -TechniqueIds $MitreTechniques"
            }
            if ($MitreAreas) {
                $tmpStr = $tmpStr + " -AreaNames $MitreAreas"
            }
        }

        if ($MitreTechniques) {
            $queryObj = Get-Queries -TechniqueIds $MitreTechniques
        }
        elseif ($MitreAreas) {
            $queryObj = Get-Queries -AreaNames $MitreAreas
        }
        elseif (($MitreTechniques) -and ($MitreAreas)) {
            $queryObj = Get-Queries -TechniqueIds $MitreTechniques -AreaNames $MitreAreas
        }

        if ($queryObj) {

            $tmp = get-date -f yyyyMMddHHmmss
    
            $yamlPath = $Path + "\" + $tmp + "_EventList-Queries\yaml\"
            New-Item -ItemType directory -Path $Path\$tmp"_EventList-Queries"
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
                    if ($old_areaName) {
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
                    "Processing " + $title + "`r`n" >> $Path\$tmp"_EventList-Queries\SigmaLog.txt"
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
                        $sigmaConfigPath = Join-Path -Path $sigmaLocation -ChildPath "..\config\generic\windows-audit.yml" -Resolve
                        $sigmaquery = python.exe $sigmaLocation -t $target ($yamlPath + $filename) -c $sigmaConfigPath 2>>$Path\$tmp"_EventList-Queries\SigmaLog.txt"

                        if ($sigmaquery) {
                            $addQuery = $true
                        }
    
                        $tmpStr = $tmpStr + "    " + $sigmaquery + "`r`n"
                        if ($addQuery) {
                            $scriptStr = $scriptStr + $sigmaquery + "`r`n`r`n"
                        }
                    }
                    else {
                        $tmpStr = $tmpStr + "    python.exe tools/sigmac -t $target $yamlFile -c config\generic\windows-audit.yml `r`n"
                        $addQuery = $true
                        $scriptStr = $scriptStr + "python.exe tools/sigmac -t $target $yamlFile -c config\generic\windows-audit.yml `r`n`r`n"
                    }
                }
    
                if ($addQuery) {
                    $outputStr = $outputStr + $tmpStr
                }
    
                $old_areaName = $area_name
                $old_techniqueName = $technique_name
            }
    
            Set-Content -Path $Path\$tmp"_EventList-Queries\EventList-Queries.md" -Value $outputStr

            if ($scriptStr) {
                Set-Content -Path $Path\$tmp"_EventList-Queries\EventList-Queries.txt" -Value $scriptStr
            }
        }
    
    }

}