function Remove-AllBaselines {

<#
    .SYNOPSIS
    Deletes all imported baselines from the database.

    .DESCRIPTION
    Deletes all imported baselines from the database.

	.PARAMETER Confirm
	Prompts you for confirmation before executing the command.

	.PARAMETER WhatIf
	Displays a message that describes the effect of the command, instead of executing the command.

    .EXAMPLE
    Remove-AllBaselines

	Deletes all imported baselines from the database.

#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
	[CmdletBinding(SupportsShouldProcess)]
	param ()

    $Query = "delete from baseline_data; delete from baseline_main;"

    Invoke-SqliteQuery -Query $Query -DataSource $Database

    $returnStr = "All baselines were successfully deleted."

    if ($Script:openFromGui) {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup($returnStr,0,"Done",0x1)
    }
    

}