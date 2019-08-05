function Remove-EventListConfiguration {

<#
    .SYNOPSIS
    Deletes all existent EventList configurations from the database.

    .DESCRIPTION
    Deletes all existent EventList configurations from the database.

	.PARAMETER sigmaPath
	Defines the path where sigmac is located.

	.PARAMETER Confirm
	Prompts you for confirmation before executing the command.

	.PARAMETER WhatIf
	Displays a message that describes the effect of the command, instead of executing the command.

    .EXAMPLE
    Remove-EventListConfiguration -sigmaPath

	Deletes all existent EventList configurations from the database.

#>
	[CmdletBinding(SupportsShouldProcess)]
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