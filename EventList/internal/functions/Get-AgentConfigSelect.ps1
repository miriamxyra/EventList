
function Get-AgentConfigSelect {

<#
    .SYNOPSIS
    Displays the form to select and display the Agent config of your choice.

    .DESCRIPTION
    Displays the form to select and display the Agent config of your choice. All Agent Forwarders are pulled out of the database and are being supported by Sigma.

    .EXAMPLE
    Get-AgentConfigSelect

    Displays the form to select and display the Agent config of your choice.

#>
	[CmdletBinding()]
	param ()

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 700
    $Form.height = 550
    $Form.Text = "Import Baseline"

    $Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10)
    $Form.Font = $Font

    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Location = '40,40'
    $MyGroupBox.size = '600,350'
    $MyGroupBox.text = "For which forwarder agent would you like to generate a configuration snippet?"


    $ComboBox2                       = New-Object system.Windows.Forms.ComboBox
    $query = "select name from agent_forwarder_syntax;"
    $agentFwdNames = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty name

    if ([string]::IsNullOrEmpty($agentFwdNames)) {
        $ComboBox2.text = "No Agent Forwarder implemented"
    }
    else {
        $ComboBox2.text = "Select an option..."
    }


    $ComboBox2.width                 = 580
    $ComboBox2.height                = 40

    $agentFwdNames | ForEach-Object {[void] $ComboBox2.Items.Add($_)}
    $ComboBox2.location              = New-Object System.Drawing.Point(50,85)
    $ComboBox2.Font                  = 'Microsoft Sans Serif,11'
    $ComboBox2.Add_SelectedValueChanged({
        If ((!([string]::IsNullOrEmpty($ComboBox2.Text))) -and ($ComboBox2.Text -in $agentFwdNames)) {
            Get-AgentConfigString -ForwarderName $ComboBox2.Text
        }
    })

    $Script:agentSnippetBox = New-Object System.Windows.Forms.TextBox
    $agentSnippetBox.Multiline = $True;
    $agentSnippetBox.Location = New-Object System.Drawing.Size(50,130)
    $agentSnippetBox.Size = New-Object System.Drawing.Size(580,250)
    $agentSnippetBox.Scrollbars = "Vertical"
    $form.Controls.Add($agentSnippetBox)

    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = '230,425'
    $OKButton.Size = '100,40'
    $OKButton.Text = 'OK'
    $OKButton.DialogResult=[System.Windows.Forms.DialogResult]::OK

    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = '355,425'
    $CancelButton.Size = '100,40'
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult=[System.Windows.Forms.DialogResult]::Cancel

    $Form.controls.AddRange(@($ComboBox2))
    $form.Controls.AddRange(@($MyGroupBox,$OKButton,$CancelButton))

    $form.AcceptButton = $OKButton
    $form.CancelButton = $CancelButton

    $form.Add_Shown({$form.Activate()})

    $form.ShowDialog()
}