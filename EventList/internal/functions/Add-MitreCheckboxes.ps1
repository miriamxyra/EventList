function Add-MitreCheckboxes {

<#
    .SYNOPSIS
    Populates all the MITRE ATT&CK checkboxes.

    .DESCRIPTION
    Populates all the MITRE ATT&CK checkboxes in the EventList GUI. Used for initial creation of the checkboxes and the CheckedListBoxes

    .EXAMPLE
    Add-MitreCheckboxes

    Populates all the MITRE ATT&CK checkboxes.

#>
	
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding()]
	param ()

    $query = "select id, area_name from mitre_areas;"

    $Script:areas = Invoke-SqliteQuery -Query $Query -DataSource $Database

    $Script:CheckBox = [ordered]@{}
    $Script:CheckBoxArea = [ordered]@{}


    $i=1
    $j = 0

    $width = 350
    $height = 200
    $x = 10
    $y = 20 + 60

    foreach ($area in $areas) {

        $x = $x +2
        $CheckBoxArea[$area.area_name]                       = New-Object system.Windows.Forms.CheckBox
        $CheckBoxArea[$area.area_name].text                  = $area.area_name
        $CheckBoxArea[$area.area_name].AutoSize              = $false
        $CheckBoxArea[$area.area_name].width                 = 300
        $CheckBoxArea[$area.area_name].height                = 20
        $CheckBoxArea[$area.area_name].location              = New-Object System.Drawing.Point($x,$y)
        $CheckBoxArea[$area.area_name].Font                  = 'Microsoft Sans Serif,12'
        $CheckBoxArea[$area.area_name].Tag                   = @{AreaName = $area.area_name}
        $CheckBoxArea[$area.area_name].Add_Click({
            param($Sender) & Select-AllCheckboxesFromOneArea -AreaName $($Sender.Tag.AreaName)
         })
        $x = $x -2
        $y = $y + 25

        $Form.controls.AddRange(@($CheckBoxArea[$area.area_name]))

        $tmp = New-Object system.Windows.Forms.CheckedListBox

        $tmp.AutoSize = $false
        $tmp.width = $width
        $tmp.height = $height
        $tmp.CheckOnClick = $true
        $tmp.location = New-Object System.Drawing.Point($x,$y)
        $tmp.Font = 'Microsoft Sans Serif,10'

        $query = "select distinct ma.area_name, mt.technique_id, mt.technique_name from mitre_events me, events_main em, mitre_techniques mt, mitre_areas ma where me.technique_id = mt.id and me.event_id = em.id and me.area_id = ma.id and ma.id = '" + $area.id + "' order by technique_name;"

        $techniques = Invoke-SqliteQuery -Query $query -DataSource $Database

        foreach ($technique in $techniques) {
            $tmp.Items.Add($technique.technique_id + " " + $technique.technique_name,$false) | Out-Null
        }

        $y = $y - 25

        $i++

        if ($x -gt 750){
            $x = 10
            $y = $y + 225
            $i = 1
        }

        $CheckBox.add( $area.area_name, $tmp )

        if ($i -ne 1) {
            $x = $x + 380
        }

        $j = $j + 1

    }

        foreach ($key in $CheckBox.keys) {
            $Form.controls.AddRange($CheckBox[$key])
        }

}