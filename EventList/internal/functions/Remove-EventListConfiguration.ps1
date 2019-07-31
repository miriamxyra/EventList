function Remove-EventListConfiguration {

<#
    .SYNOPSIS
    Deletes all existent EventList configurations from the database.

    .DESCRIPTION
    Deletes all existent EventList configurations from the database.

    .EXAMPLE
    Remove-EventListConfiguration -sigmaPath

#>
	[CmdletBinding()]
    param(
        [switch]$sigmaPath
    )

    if ($sigmaPath) {
        $query = "Update EventList_configuration set sigma_path='' where id=1;"
    }

    if ($query) {
        Invoke-SqliteQuery -Query $query -DataSource $database
    }
}