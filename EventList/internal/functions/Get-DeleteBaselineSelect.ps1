function Get-DeleteBaselineSelect {

<#
    .SYNOPSIS
    Shows a pop-up in which the deletion options are being displayed.

    .DESCRIPTION
    Shows a pop-up in which the deletion options are being displayed: Delete the selected baseline or Delete all baselines

    .EXAMPLE
    Get-DeleteBaselineSelect

    Shows a pop-up in which the deletion options are being displayed.

#>

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 700
    $Form.height = 350
    $Form.Text = "Delete Baseline"

    $Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10)
    $Form.Font = $Font

    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Location = '40,40'
    $MyGroupBox.size = '600,150'
    $MyGroupBox.text = "Would you prefer to..."

    $RadioButton1 = New-Object System.Windows.Forms.RadioButton
    $RadioButton1.Location = '20,50'
    $RadioButton1.size = '450,30'
    $RadioButton1.Checked = $true
    $RadioButton1.Text = "Delete the selected baseline"

    $RadioButton2 = New-Object System.Windows.Forms.RadioButton
    $RadioButton2.Location = '20,85'
    $RadioButton2.size = '450,30'
    $RadioButton2.Checked = $false
    $RadioButton2.Text = "Delete all baselines"

    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = '230,200'
    $OKButton.Size = '100,40'
    $OKButton.Text = 'OK'
    $OKButton.DialogResult=[System.Windows.Forms.DialogResult]::OK

    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = '355,200'
    $CancelButton.Size = '100,40'
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult=[System.Windows.Forms.DialogResult]::Cancel

    $form.Controls.AddRange(@($MyGroupBox,$OKButton,$CancelButton))

    $MyGroupBox.Controls.AddRange(@($Radiobutton1,$RadioButton2,$RadioButton3))

    $form.AcceptButton = $OKButton
    $form.CancelButton = $CancelButton

    $form.Add_Shown({$form.Activate()})

    $dialogResult = $form.ShowDialog()

    if ($dialogResult -eq "OK"){

        if ($RadioButton1.Checked){
            Remove-OneBaseline -BaselineName $ComboBox1Value
            Reset-MitreCheckboxes
            $baselineNames = Get-BaselineNamesFromDB
            Sync-ComboBox -ComboBox $ComboBox1 -Items $baselineNames
        }
        elseif ($RadioButton2.Checked){
            Remove-AllBaselines
            Reset-MitreCheckboxes
            $baselineNames = Get-BaselineNamesFromDB
            Sync-ComboBox -ComboBox $ComboBox1 -Items $baselineNames
        }
    }
}