function Remove-AllYamlConfigurations {

<#
    .SYNOPSIS
    Deletes all imported YAML configuration files from the database.

    .DESCRIPTION
    Deletes all imported YAML configuration files from the database.

	.PARAMETER Confirm
	Prompts you for confirmation before executing the command.

	.PARAMETER WhatIf
	Displays a message that describes the effect of the command, instead of executing the command.

    .EXAMPLE
    Remove-AllYamlConfigurations

	Deletes all imported YAML configuration files from the database.

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding(SupportsShouldProcess)]
	param ()

    $Query = "delete from queries_data_yaml_main; delete from queries_data_yaml_tags;"

    Invoke-SqliteQuery -Query $Query -DataSource $Database
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("All YAML configurations were successfully deleted.",0,"Done",0x1)
}