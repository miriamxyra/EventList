function Get-PolicyFromEvents {

<#
    .SYNOPSIS
    Creates a group policy out of the selected events.

    .DESCRIPTION
    Creates a group policy out of the selected events which are mapped to the MITRE ATT&CK Techniques.

    .EXAMPLE
    Get-PolicyFromEvents

    Creates a group policy out of the selected events.

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseOutputTypeCorrectly", "")]
	[CmdletBinding()]
	param ()

    $destFolder = Start-FilePicker -description "Select a directory where the GPO should be saved"
    $GpoTmpl = "$ModuleRoot\internal\data\GPO\*"

    $tmp = Get-MitreEvents -advancedAudit

    if ($tmp) {
        $auditCsvString = "Machine Name,Policy Target,Subcategory,Subcategory GUID,Inclusion Setting,Exclusion Setting,Setting Value"

        foreach ($item in $tmp) {
            $subcategory_name = $item | Select-Object -ExpandProperty subcategory_name
            $guid = $item | Select-Object -ExpandProperty guid
            $sf_sum = $item | Select-Object -ExpandProperty sf_sum

            switch ($sf_sum){
                # if success_failure_id >= 3 it's always s+f / 1 = s / 2 = f
                0 {""}
                1 {
                    $sf_string = "Success"
                    $sf_number = $sf_sum
                }
                2 {
                    $sf_string = "Failure"
                    $sf_number = $sf_sum
                }
                default {
                    $sf_string = "Success and Failure"
                    $sf_number = 3
                }
                }

            $auditCsvString = $auditCsvString + "`r`n,System,$subcategory_name,$guid,$sf_string,,$sf_number"
        }

        $GPOFolder = $("{$(New-Guid)}").ToUpper()

        New-Item -ItemType directory -Path "$destFolder\$GPOFolder"
        Copy-Item "$GpoTmpl" -Destination "$destFolder\$GPOFolder" -Recurse

        New-Item -ItemType directory -Path "$destFolder\$GPOFolder\Machine\Microsoft\Windows NT\Audit\"

        New-Item -ItemType directory -Path "$destFolder\$GPOFolder\Machine\Scripts\Shutdown\"
        New-Item -ItemType directory -Path "$destFolder\$GPOFolder\Machine\Scripts\Startup\"
        New-Item -ItemType directory -Path "$destFolder\$GPOFolder\User\"

        Set-Content -Path "$destFolder\$GPOFolder\Machine\Microsoft\Windows NT\Audit\audit.csv" -Value $auditCsvString
    }

}