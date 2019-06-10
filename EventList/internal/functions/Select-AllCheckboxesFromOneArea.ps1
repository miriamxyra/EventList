function Select-AllCheckboxesFromOneArea {

<#
    .SYNOPSIS
    Selects all Checkboxes of the techniques mapped to an area.

    .DESCRIPTION
    Selects all Checkboxes of the techniques mapped to an area.

    .PARAMETER AreaName
    The name of the area.

    .EXAMPLE
    Select-AllCheckboxesFromOneArea -AreaName "Initial Access"

#>

    param (
        [string]$AreaName
    )

        if ($CheckBoxArea[$AreaName].checked) {
            $isChecked = $true
        }
        else {
            $isChecked = $false
        }

        for ($i=0; $i -lt $CheckBox[$AreaName].Items.count; $i++) {
            $CheckBox[$AreaName].SetItemChecked($i, $isChecked)
        }

}