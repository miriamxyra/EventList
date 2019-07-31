function Get-MitreEventList {

<#
    .SYNOPSIS
    Gets an EventList for the selected MITRE ATT&CK techniques.

    .DESCRIPTION
    Gets an EventList for the MITRE ATT&CK techniques which were selected from the checkboxes in the GUI.

    .EXAMPLE
    Get-MitreEventList -generateExcelYsn $true

    Gets an EventList for the selected MITRE ATT&CK techniques.

#>
	[CmdletBinding()]
    param (
        [boolean]$generateExcelYsn = $false
    )

    $results = Get-MitreEvents
    if (![string]::IsNullOrEmpty($results)) {
            if ($generateExcelYsn) {
                $tmp = get-date -f yyyyMMddHHmmss
                $results | Export-Csv -Path $ExportFolder\$tmp"EventList.csv"
            }
            else {
                $results | Out-GridView -Title "EventList for: $ComboBox1Value"
            }

    }
    else {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("No MITRE ATT&CK techniques were selected.",0,"Done",0x1)
    }


}