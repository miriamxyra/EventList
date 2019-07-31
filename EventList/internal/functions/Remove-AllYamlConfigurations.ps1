function Remove-AllYamlConfigurations {

<#
    .SYNOPSIS
    Deletes all imported YAML configuration files from the database.

    .DESCRIPTION
    Deletes all imported YAML configuration files from the database.

    .EXAMPLE
    Remove-AllYamlConfigurations

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding()]
	param ()

    $Query = "delete from queries_data_yaml_main; delete from queries_data_yaml_tags;"

    Invoke-SqliteQuery -Query $Query -DataSource $Database
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("All YAML configurations were successfully deleted.",0,"Done",0x1)
}