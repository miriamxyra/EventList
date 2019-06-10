function Get-SigmaPath {

<#
    .SYNOPSIS
    Returns the path to the location where sigmac is located.

    .DESCRIPTION
    Returns the path to the location where sigmac is located. The path is configured by the user.

    .EXAMPLE
    Get-SigmaPath

    Returns the path to the location where sigmac is located.

#>

    $query = "select sigma_path from EventList_configuration;"

    $sigmaPath = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty sigma_path

    $sigmaPath = $sigmaPath

    if (!(Test-Path -Path "$sigmaPath\sigmac" -PathType Leaf)) {
        return ""
    }
    else {
        return "$sigmaPath\sigmac"
    }

}