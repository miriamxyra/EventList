function Get-BaselineEventList {

<#
    .SYNOPSIS
    Gets an EventList for the selected Baseline.

    .DESCRIPTION
    Gets an EventList for the Baseline which was selected from the Combobox in the GUI.

    .PARAMETER BaselineName
    Prompts you for the Baseline Name that should be used to generate an EventList from.

	.PARAMETER generateExcelYsn
	Defines if an Excel document will be generated. When checked, one can define where the document should be stored.

    .EXAMPLE
    Get-BaselineEventList -generateExcelYsn $true

    Gets an EventList for the selected Baseline.

#>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
	[CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$True)]
        [string]$BaselineName,
        [boolean]$generateExcelYsn = $false
    )

    process {

        if ($Script:openFromGui) {
            $BaselineName = $ComboBox1Value
        }

        if (($BaselineName -eq "No Baselines imported") -or ($BaselineName -eq "Select Baseline") -or [string]::IsNullOrEmpty($BaselineName)){
            $returnStr = "No Baseline was selected."
            if ($Script:openFromGui) {
                    $wshell = New-Object -ComObject Wscript.Shell
                    $wshell.Popup($returnStr,0,"Generate EventList",0x1)
            }
            else {
                Write-Host $returnStr
            }
        }
        else {
            $BaselineName = ConvertTo-PSSQLString($BaselineName)
            $query = "select eaac.category_name as Category, d.subcategory as Subcategory, em.id as 'Event ID', em.event_name as 'Event Description', em.link_text as 'Event Link', d.inclusion_setting as 'Audit Recommendation', d.setting_value 'Audit Recommendation Number', sf.success_failure_name as 'Event S/F', d.policy_target as 'Policy Target', sr.sec_rec_name as Recommendation from baseline_main m, baseline_data d, events_main em, events_source so, events_success_failure sf, events_security_recommendation sr, events_audit_subcategory eas, events_advanced_audit_categories eaac, events_advanced_audit_subcategories eaas where m.id = d.b_id and d.subcategory = eaas.subcategory_name and em.so_id = so.id and em.success_failure_id = sf.id and em.sr_id = sr.id and em.id = eas.event_id and eas.audit_subc_id = eaas.id and eaas.c_id = eaac.id and m.name = '$BaselineName';"
            $results = Invoke-SqliteQuery -Query $query -DataSource $database
            if ($generateExcelYsn) {
                $tmp = get-date -f yyyyMMddHHmmss
                $results | Export-Csv -Path $ExportFolder\$tmp"EventList.csv"
            }
            else {
                if ($Script:openFromGui) {
                    $BaselineName = ConvertFrom-PSSQLString($BaselineName)
                    $results | Out-GridView -Title "EventList for: $BaselineName"
                }
                else {
                    return $results
                }
            }

        }

    }

}

