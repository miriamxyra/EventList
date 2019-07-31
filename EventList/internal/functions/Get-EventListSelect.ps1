function Get-EventListSelect {

<#
    .SYNOPSIS
    Shows a pop-up in which the EventList generation options are being displayed.

    .DESCRIPTION
    Shows a pop-up in which the EventList generation options are being displayed.

    .EXAMPLE
    Get-EventListSelect

    Shows a pop-up in which the EventList generation options are being displayed.

#>
	[CmdletBinding()]
	param ()

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 700
    $Form.height = 400
    $Form.Text = "EventList"

    $Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10)
    $Form.Font = $Font

    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Location = '40,40'
    $MyGroupBox.size = '600,200'
    $MyGroupBox.text = "Which Events would you like to process?"

    $RadioButton1 = New-Object System.Windows.Forms.RadioButton
    $RadioButton1.Location = '20,50'
    $RadioButton1.size = '450,30'
    $RadioButton1.Checked = $true
    $RadioButton1.Text = "Baseline Events only"

    $RadioButton2 = New-Object System.Windows.Forms.RadioButton
    $RadioButton2.Location = '20,85'
    $RadioButton2.size = '450,30'
    $RadioButton2.Checked = $false
    $RadioButton2.Text = "All MITRE ATT&&CK Events"

    $Checkbox1 = New-Object System.Windows.Forms.Checkbox
    $Checkbox1.Location = '50,130'
    $Checkbox1.size = '350,30'
    $Checkbox1.Checked = $false
    $Checkbox1.Text = "Export as CSV"
    $Checkbox1.Add_Click({
        $Script:ExportFolder = Start-FilePicker -description "Please select where to store your Excel file"
     })

    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = '230,250'
    $OKButton.Size = '100,40'
    $OKButton.Text = 'OK'
    $OKButton.DialogResult=[System.Windows.Forms.DialogResult]::OK

    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = '355,250'
    $CancelButton.Size = '100,40'
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult=[System.Windows.Forms.DialogResult]::Cancel

    $form.Controls.AddRange(@($MyGroupBox,$OKButton,$CancelButton))

    $MyGroupBox.Controls.AddRange(@($Radiobutton1,$RadioButton2,$Checkbox1))

    $form.AcceptButton = $OKButton
    $form.CancelButton = $CancelButton

    $form.Add_Shown({$form.Activate()})

    $dialogResult = $form.ShowDialog()

    if ($dialogResult -eq "OK"){
        if ($RadioButton1.Checked){
            Get-BaselineEventList -generateExcelYsn $Checkbox1.Checked
        }
        elseif ($RadioButton2.Checked){
            Get-MitreEventList -generateExcelYsn $Checkbox1.Checked
        }
    }
}