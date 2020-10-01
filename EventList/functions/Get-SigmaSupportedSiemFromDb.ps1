function Get-SigmaSupportedSiemFromDb {

<#
    .SYNOPSIS
    Returns all SIEM systems which are supported by sigma.

    .DESCRIPTION
    Returns all SIEM systems which are supported by sigma.

    .EXAMPLE
    Get-SigmaSupportedSiemFromDb

    Returns all SIEM systems which are supported by sigma.

#>
	[CmdletBinding()]
	param ()

    $query = "select name from sigma_supportedSiem order by name;"

    $siemNames = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty name

    return $siemNames
}