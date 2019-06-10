function Sync-MitreCheckboxes {

<#
    .SYNOPSIS
    Syncs all Mitre Checkboxes according to the selected baseline.

    .DESCRIPTION
    Syncs all Mitre Checkboxes according to the selected baseline.

    .EXAMPLE
    Sync-MitreCheckboxes -BaselineName "SCM Windows 10 - Computer"

#>

    param (
        [string]$BaselineName
    )

    if (![string]::IsNullOrEmpty($BaselineName)) {

        $query = "select distinct a.area_name as area_name, a.area_id as area_id, a.technique_name as technique_name, a.technique_id as technique_id, b.baseline_name as baseline_name from ( select * from v_mitre_matches_baseline ) a left join ( select * from v_mitre_matches_baseline where baseline_name = '" + $BaselineName + "' ) b on a.technique_id = b.technique_id order by a.area_id, a.technique_name;"
        $results = Invoke-SqliteQuery -Query $Query -DataSource $Database

            $i=0

            foreach ($result in $results) {

                if (($old_area_name) -and ($old_area_name -ne $result.area_name)) {
                    if ($i -eq $cntChecked) {
                        $CheckBoxArea[$old_area_name].checked = $true
                    }
                    else {
                        $CheckBoxArea[$old_area_name].checked = $false
                    }

                    $i = 0
                    $cntChecked = 0
                }

                if (![string]::IsNullOrEmpty($result.baseline_name)) {
                    $CheckBox[$result.area_name].SetItemChecked($i, $true)
                    $cntChecked = $cntChecked + 1
                }
                else {
                    $CheckBox[$result.area_name].SetItemChecked($i, $false)
                }
                $old_area_name = $result.area_name


                $i = $i + 1
            }

    }
}