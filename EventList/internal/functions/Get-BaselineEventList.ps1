function Get-BaselineEventList {

<#
    .SYNOPSIS
    Gets an EventList for the selected Baseline.

    .DESCRIPTION
    Gets an EventList for the Baseline which was selected from the Combobox in the GUI.

    .EXAMPLE
    Get-BaselineEventList -generateExcelYsn $true

    Gets an EventList for the selected Baseline.

#>

    param (
        [boolean]$generateExcelYsn = $false
    )

    if (($ComboBox1Value -eq "No Baselines imported") -or ($ComboBox1Value -eq "Select Baseline") -or [string]::IsNullOrEmpty($ComboBox1Value)) {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("No Baseline was selected.",0,"Generate EventList",0x1)
    }
    else {
        $query = "select eaac.category_name as Category, d.subcategory as Subcategory, em.id as 'Event ID', em.event_name as 'Event Description', em.link_text as 'Event Link', d.inclusion_setting as 'Audit Recommendation', d.setting_value 'Audit Recommendation Number', sf.success_failure_name as 'Event S/F', d.policy_target as 'Policy Target', sr.sec_rec_name as Recommendation from baseline_main m, baseline_data d, events_main em, events_source so, events_success_failure sf, events_security_recommendation sr, events_audit_subcategory eas, events_advanced_audit_categories eaac, events_advanced_audit_subcategories eaas where m.id = d.b_id and d.subcategory = eaas.subcategory_name and em.so_id = so.id and em.success_failure_id = sf.id and em.sr_id = sr.id and em.id = eas.event_id and eas.audit_subc_id = eaas.id and eaas.c_id = eaac.id and m.name = '$ComboBox1Value';"
        $results = Invoke-SqliteQuery -Query $query -DataSource $database
        if ($generateExcelYsn) {
            $tmp = get-date -f yyyyMMddHHmmss
            $results | Export-Csv -Path $ExportFolder\$tmp"EventList.csv"
        }
        else {
            $results | Out-GridView -Title "EventList for: $ComboBox1Value"
        }

    }



}

