function Get-MitreEventList {

    <#
    .SYNOPSIS
    Gets an EventList for the selected MITRE ATT&CK techniques.

    .DESCRIPTION
    Gets an EventList for the MITRE ATT&CK techniques which were selected from the checkboxes in the GUI.

    .PARAMETER Identity
	Defines which MITRE ATT&CK Techniques or which Microsoft Security Baseline should be used as Input to generate a Mitre EventList.

	.PARAMETER generateExcelYsn
	Defines if an Excel document will be generated. When checked, one can define where the document should be stored.

    .EXAMPLE
    Get-MitreEventList -generateExcelYsn $true

    Gets an EventList for the selected MITRE ATT&CK techniques.

#>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('BaselineName', 'TechniqueId')]
        [string]
        $Identity,
        [boolean]$generateExcelYsn = $false
    )

    process {

        if ($Script:openFromGui) {
            $results = Get-MitreEvents -MitreTechniques $(Get-CheckedMitreTechniques)
        }
        else {
            if ($identity) {
                if (Get-BaselineNameFromDB -BaselineName $Identity) {
                    $tmpStr = Get-MitreTechniquesFromBaseline -BaselineName $Identity
                    if ($tmpStr) {
                        $results = Get-MitreEvents -MitreTechniques $tmpStr
                    }
                }
                elseif ($Identity -match "^T\d{4}$") {
                    $results = Get-MitreEvents -MitreTechniques $("'" + $Identity + "'")
                }
                elseif ( ($Identity -match "^['T\d{4}$]") -or ($Identity -match "^T\d{4}$") ) {
                    $results = Get-MitreEvents -MitreTechniques $Identity
                }
            }
        }
        
        if (![string]::IsNullOrEmpty($results)) {
            if ($generateExcelYsn) {
                $tmp = get-date -f yyyyMMddHHmmss
                $results | Export-Csv -Path $ExportFolder\$tmp"EventList.csv"
            }
            else {
                if ($Script:openFromGui) {
                    $results | Out-GridView -Title "EventList for: $ComboBox1Value"
                }
                else {
                    $results
                }
            }

        }
        else {
            $returnStr = "No MITRE ATT&CK techniques were selected."
            if ($Script:openFromGui) {
                $wshell = New-Object -ComObject Wscript.Shell
                $wshell.Popup($returnStr, 0, "Done", 0x1)
            }
            else {
                Write-Host $returnStr
            }
        }
    }

}