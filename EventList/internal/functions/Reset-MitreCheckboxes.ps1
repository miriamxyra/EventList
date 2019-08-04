function Reset-MitreCheckboxes {

<#
    .SYNOPSIS
    Unchecks all checked MITRE ATT&CK technique & area checkboxes.

    .DESCRIPTION
    Unchecks all checked MITRE ATT&CK technique & area checkboxes. Also resets the baseline combobox selection.

    .EXAMPLE
    Reset-MitreCheckboxes

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding(SupportsShouldProcess)]
	param ()

    foreach ($key in $CheckBox.keys) {
        for ($i=0; $i -lt $CheckBox[$key].Items.count; $i++) {
            $CheckBox[$key].SetItemChecked($i, $false)
        }
    }

    foreach ($key in $CheckBoxArea.keys) {
        $($CheckBoxArea[$key]).checked = $false
    }

    $ComboBox1Value = ""
    $ComboBox1.text = "Select Baseline"
}