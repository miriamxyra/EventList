function Remove-AllBaselines {

<#
    .SYNOPSIS
    Deletes all imported baselines from the database.

    .DESCRIPTION
    Deletes all imported baselines from the database.

    .EXAMPLE
    Remove-AllBaselines

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding(SupportsShouldProcess)]
	param ()

    $Query = "delete from baseline_data; delete from baseline_main;"

    Invoke-SqliteQuery -Query $Query -DataSource $Database
    $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("All baselines were successfully deleted.",0,"Done",0x1)

}