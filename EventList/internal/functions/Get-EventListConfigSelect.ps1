function Get-EventListConfigSelect {

<#
    .SYNOPSIS
    Shows a pop-up in which the EventList configuration options are being displayed.

    .DESCRIPTION
    Shows a pop-up in which the EventList configuration options are being displayed.

    .EXAMPLE
    Get-EventListConfigSelect

    Shows a pop-up in which the EventList configuration options are being displayed.

#>
	[CmdletBinding()]
	param ()

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 700
    $Form.height = 400
    $Form.Text = "Configure EventList"

    $Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10)
    $Form.Font = $Font

    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Location = '40,40'
    $MyGroupBox.size = '600,200'
    $MyGroupBox.text = "Configure EventList"

    $Checkbox1 = New-Object System.Windows.Forms.Checkbox
    $Checkbox1.Location = '20,50'
    $Checkbox1.size = '500,90'
    $sigmaPath = Get-SigmaPath
    if ($sigmaPath) {
        $Checkbox1.Checked = $true
        $Checkbox1.Text = "Sigma Path configured: $sigmaPath"
    }
    else {
        $Checkbox1.Checked = $false
        $Checkbox1.Text = "Configure Sigma Path"
    }

    $Checkbox1.Add_Click({
        if ($Checkbox1.checked) {
            $sigmaPath = Start-FilePicker -description "Please select where to store your Excel file"
            if ($sigmaPath) {
                Add-EventListConfiguration -sigmaPath $sigmaPath
                $Checkbox1.Text = "Sigma Path configured: $sigmaPath"
            }
        }
        else {
            Remove-EventListConfiguration -sigmaPath
            $Checkbox1.Text = "Configure Sigma Path"
        }
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

    $MyGroupBox.Controls.AddRange(@($Radiobutton1,$RadioButton2,$Checkbox1,$Checkbox2))

    $form.AcceptButton = $OKButton
    $form.CancelButton = $CancelButton

    $form.Add_Shown({$form.Activate()})

    $form.ShowDialog()
}