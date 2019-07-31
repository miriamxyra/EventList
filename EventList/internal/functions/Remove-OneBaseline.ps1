function Remove-OneBaseline {

<#
    .SYNOPSIS
    Removes one imported baseline from the database.

    .DESCRIPTION
    Removes one imported baseline from the database.

    .EXAMPLE
    Remove-OneBaseline -BaselineName "SCM Windows 10 - Computer"

#>
	[CmdletBinding()]

    Param (
        [string]$BaselineName
    )

    $valuesFromDb = Get-BaselineNamesFromDB

    if (($BaselineName -eq "No Baselines imported") -or ($BaselineName -eq "Select Baseline") -or [string]::IsNullOrEmpty($BaselineName)) {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("No Baseline was selected.",0,"Delete selected baseline",0x1)
    }
    else {
        If ($BaselineName -in $valuesFromDb) {
            $query = "select id from baseline_main where name like '$BaselineName' ;"
            $id = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty id

            $query = "delete from baseline_data where b_id = $id ; delete from baseline_main where id = $id ;"
            Invoke-SqliteQuery -Query $query -DataSource $database

            $wshell = New-Object -ComObject Wscript.Shell
            $wshell.Popup("Baseline $BaselineName was deleted successfully.",0,"Delete selected baseline",0x1)
        }
    }
}