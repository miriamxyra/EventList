function Get-BaselineNamesFromDB {

<#
    .SYNOPSIS
    Gets all the names of the baselines, stored in the database.

    .DESCRIPTION
    Gets all the names of the baselines, stored in the database.

    .EXAMPLE
    Get-BaselineNamesFromDB

    Gets all the names of the baselines, stored in the database.

#>

	[CmdletBinding()]
	param ()

    $query = "select name from baseline_main;"

    $baselineNames = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty name

    return $baselineNames
}