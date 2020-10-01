function Remove-OneBaseline {

    <#
    .SYNOPSIS
    Removes one imported baseline from the database.

    .DESCRIPTION
    Removes one imported baseline from the database.

	.PARAMETER BaselineName
	Defines the name of the baseline.

	.PARAMETER Confirm
	Prompts you for confirmation before executing the command.

	.PARAMETER WhatIf
	Displays a message that describes the effect of the command, instead of executing the command.

    .EXAMPLE
    Remove-OneBaseline -BaselineName "SCM Windows 10 - Computer"

	Removes one imported baseline from the database.

#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [string]$BaselineName
    )

    process {

        $valuesFromDb = Get-BaselineNameFromDB

        if (($BaselineName -eq "No Baselines imported") -or ($BaselineName -eq "Select Baseline") -or [string]::IsNullOrEmpty($BaselineName)) {
            $returnStr = "No Baseline was selected."
        
            if ($Script:openFromGui) {
                $wshell = New-Object -ComObject Wscript.Shell
                $wshell.Popup($returnStr, 0, "Delete selected baseline", 0x1)
            }
            Write-Host $returnStr
        }
        else {
            If ($BaselineName -in $valuesFromDb) {
                $query = "select id from baseline_main where name like '$BaselineName' ;"
                $id = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty id

                $query = "delete from baseline_data where b_id = $id ; delete from baseline_main where id = $id ;"
                Invoke-SqliteQuery -Query $query -DataSource $database

                $returnStr = "Baseline $BaselineName was deleted successfully."

                if ($Script:openFromGui) {
                    $wshell = New-Object -ComObject Wscript.Shell
                    $wshell.Popup($returnStr, 0, "Delete selected baseline", 0x1)
                }
            }
        }
    }
}