function Get-QueriesSelect {

<#
    .SYNOPSIS
    Shows a pop-up in which the query creation options are being displayed.

    .DESCRIPTION
    Shows a pop-up in which the query creation options are being displayed.

    .EXAMPLE
    Get-QueriesSelect

    Shows a pop-up in which the query creation options are being displayed.

#>

	[CmdletBinding()]
	param ()

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 700
    $Form.height = 400
    $Form.Text = "Generate Queries"

    $Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10)
    $Form.Font = $Font

    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Location = '40,40'
    $MyGroupBox.size = '600,200'
    $MyGroupBox.text = "How would you like to create your queries?"

    $RadioButton1 = New-Object System.Windows.Forms.RadioButton
    $RadioButton1.Location = '20,50'
    $RadioButton1.size = '450,30'
    $RadioButton1.Checked = $true
    $RadioButton1.Text = "Please generate SIGMA queries for:"

    $ComboSiemBox                       = New-Object system.Windows.Forms.ComboBox
    $supportedSiem = Get-SupportedSiemFromDb
    if ([string]::IsNullOrEmpty($supportedSiem)) {
        $ComboSiemBox.text = "No supported Siem solution imported"
    }
    else {
        $ComboSiemBox.text = "Select Siem solution"
    }


    $ComboSiemBox.width                 = 200
    $ComboSiemBox.height                = 40

    $supportedSiem | ForEach-Object {[void] $ComboSiemBox.Items.Add($_)}
    $ComboSiemBox.location              = New-Object System.Drawing.Point(76,120)
    $ComboSiemBox.Font                  = 'Microsoft Sans Serif,11'

    $ComboSiemBox.Add_SelectedValueChanged({
        $Script:SelectedComboSiemBox = $ComboSiemBox.Text
    })

    $Form.controls.AddRange(@($ComboSiemBox))

    $RadioButton2 = New-Object System.Windows.Forms.RadioButton
    $RadioButton2.Location = '20,115'
    $RadioButton2.size = '450,30'
    $RadioButton2.Checked = $false
    $RadioButton2.Text = "Generate Queries in YAML format"

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
        if ($ExportFolder = Start-FilePicker -description "Where do you want to save your Queries?") {
            if ($RadioButton1.Checked){
                Get-SigmaQueries -OutputPath $ExportFolder -siemName $SelectedComboSiemBox
            }
            elseif ($RadioButton2.Checked){
                Get-SigmaQueries -OutputPath $ExportFolder -siemName $SelectedComboSiemBox -yamlOnly
            }
        }
    }
}