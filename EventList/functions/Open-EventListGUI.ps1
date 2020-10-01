function Open-EventListGUI {

<#
    .SYNOPSIS
    Opens the EventList GUI.

    .DESCRIPTION
    Opens the EventList GUI.

    .EXAMPLE
    Open-EventListGUI

    Opens the EventList GUI.

#>

    $Script:openFromGui = $true

    $GuiWidth = 1535
    $GuiHeight = 1000

    $ButtonWidth = 200
    $ButtonHeight = 30
    $ButtonXDistance = 215
    $ButtonYDistance = 40

    $ButtonPanelDistance = 1305

    $ComboboxWidth = 420

    $x = 10
    $y = 20 + 60

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()


    $Form                            = New-Object system.Windows.Forms.Form
    $Form.ClientSize                 = "$GuiWidth,$GuiHeight"
    $Form.text                       = "EventList"
    $Form.TopMost                    = $false

    #Panel oben mit Baseline Auswahl
    $Panel1                          = New-Object system.Windows.Forms.Panel
    $Panel1.height                   = 50
    $Panel1.width                    = 2000
    $Panel1.BackColor                = "#9b9b9b"
    $Panel1.location                 = New-Object System.Drawing.Point(0,0)

    #Panel an der Seite mit Buttons
    $Panel2                          = New-Object system.Windows.Forms.Panel
    $Panel2.height                   = 2000
    $Panel2.width                    = 235
    $Panel2.BackColor                = "#9b9b9b"
    $Panel2.location                 = New-Object System.Drawing.Point($ButtonPanelDistance,0)

    Add-MitreCheckboxes

    $x = $ButtonPanelDistance + 10
    $y = 60

    $ButtonShowEvts                         = New-Object system.Windows.Forms.Button
    $ButtonShowEvts.BackColor               = "#d5d8d7"
    $ButtonShowEvts.text                    = "Generate Event List"
    $ButtonShowEvts.width                   = $ButtonWidth
    $ButtonShowEvts.height                  = $ButtonHeight
    $ButtonShowEvts.location                = New-Object System.Drawing.Point($x,$y)
    $ButtonShowEvts.Font                    = 'Microsoft Sans Serif,11'
    $Form.controls.AddRange(@($ButtonShowEvts))
    $ButtonShowEvts.Add_Click({
        Get-EventListSelect
     })

    $y = $y + $ButtonYDistance

    $ButtonAgentCfg                         = New-Object system.Windows.Forms.Button
    $ButtonAgentCfg.BackColor               = "#d5d8d7"
    $ButtonAgentCfg.text                    = "Generate Agent Config"
    $ButtonAgentCfg.width                   = $ButtonWidth
    $ButtonAgentCfg.height                  = $ButtonHeight
    $ButtonAgentCfg.location                = New-Object System.Drawing.Point($x,$y)
    $ButtonAgentCfg.Font                    = 'Microsoft Sans Serif,11'
    $Form.controls.AddRange(@($ButtonAgentCfg))
    $ButtonAgentCfg.Add_Click({ Get-AgentConfigSelect })

    $y = $y + $ButtonYDistance

    $ButtonExportQueries                         = New-Object system.Windows.Forms.Button
    $ButtonExportQueries.BackColor               = "#d5d8d7"
    $ButtonExportQueries.text                    = "Generate Queries"
    $ButtonExportQueries.width                   = $ButtonWidth
    $ButtonExportQueries.height                  = $ButtonHeight
    $ButtonExportQueries.location                = New-Object System.Drawing.Point($x,$y)
    $ButtonExportQueries.Font                    = 'Microsoft Sans Serif,11'
    $Form.controls.AddRange(@($ButtonExportQueries))
    $ButtonExportQueries.Add_Click({
        Get-QueriesSelect
    })

    $y = $y + $ButtonYDistance

    $ButtonExportGPO                         = New-Object system.Windows.Forms.Button
    $ButtonExportGPO.BackColor               = "#d5d8d7"
    $ButtonExportGPO.text                    = "Generate GPO"
    $ButtonExportGPO.width                   = $ButtonWidth
    $ButtonExportGPO.height                  = $ButtonHeight
    $ButtonExportGPO.location                = New-Object System.Drawing.Point($x,$y)
    $ButtonExportGPO.Font                    = 'Microsoft Sans Serif,11'
    $Form.controls.AddRange(@($ButtonExportGPO))
    $ButtonExportGPO.Add_Click({ Get-GroupPolicyFromMitreTechniques })

    $y = $GuiHeight - 50

    $ButtonExit                         = New-Object system.Windows.Forms.Button
    $ButtonExit.BackColor               = "#C0C0C0"
    $ButtonExit.text                    = "Close"
    $ButtonExit.width                   = $ButtonWidth
    $ButtonExit.height                  = $ButtonHeight
    $ButtonExit.location                = New-Object System.Drawing.Point($x,$y)
    $ButtonExit.Font                    = [System.Drawing.Font]::new("Microsoft Sans Serif", 11, [System.Drawing.FontStyle]::Bold)
    $Form.controls.AddRange(@($ButtonExit))
    $ButtonExit.Add_Click({ Close-Form -Form $Form })

    $Script:ComboBox1                       = New-Object system.Windows.Forms.ComboBox
    $baselineNames = Get-BaselineNameFromDB
    if ([string]::IsNullOrEmpty($baselineNames)) {
        $ComboBox1.text = "No Baselines imported"
    }
    else {
        $ComboBox1.text = "Select Baseline"
    }


    $ComboBox1.width                 = $ComboboxWidth
    $ComboBox1.height                = 40

    $x = 20
    $y = 10

    Get-BaselineNameFromDB | ForEach-Object {[void] $ComboBox1.Items.Add($_)}
    $ComboBox1.location              = New-Object System.Drawing.Point($x,($y+2))
    $ComboBox1.Font                  = 'Microsoft Sans Serif,11'

    $ComboBox1.Add_SelectedValueChanged({
        $Script:ComboBox1Value = $ComboBox1.Text
        Sync-MitreCheckboxes -BaselineName $ComboBox1Value
    })

    $Form.controls.AddRange(@($ComboBox1))

    $x = $x + $ComboboxWidth + 15

    $ButtonImportBsl                         = New-Object system.Windows.Forms.Button
    $ButtonImportBsl.BackColor               = "#d5d8d7"
    $ButtonImportBsl.text                    = "Import Baseline(s)"
    $ButtonImportBsl.width                   = $ButtonWidth
    $ButtonImportBsl.height                  = $ButtonHeight
    $ButtonImportBsl.location                = New-Object System.Drawing.Point($x,$y)
    $ButtonImportBsl.Font                    = 'Microsoft Sans Serif,11'
    $Form.controls.AddRange(@($ButtonImportBsl))
    $ButtonImportBsl.Add_Click({
        Get-ImportSelect
    })

    $x = $x + $ButtonXDistance

    $ButtonDelOneBaseline                         = New-Object system.Windows.Forms.Button
    $ButtonDelOneBaseline.BackColor               = "#d5d8d7"
    $ButtonDelOneBaseline.text                    = "Delete baseline(s)"
    $ButtonDelOneBaseline.width                   = $ButtonWidth
    $ButtonDelOneBaseline.height                  = $ButtonHeight
    $ButtonDelOneBaseline.location                = New-Object System.Drawing.Point($x,$y)
    $ButtonDelOneBaseline.Font                    = 'Microsoft Sans Serif,11'
    $Form.controls.AddRange(@($ButtonDelOneBaseline))
    $ButtonDelOneBaseline.Add_Click({
        Get-DeleteBaselineSelect
     })

     $x = $x + $ButtonXDistance

     $ButtonResetCheckboxes                         = New-Object system.Windows.Forms.Button
     $ButtonResetCheckboxes.BackColor               = "#d5d8d7"
     $ButtonResetCheckboxes.text                    = "Reset Checkboxes"
     $ButtonResetCheckboxes.width                   = $ButtonWidth
     $ButtonResetCheckboxes.height                  = $ButtonHeight
     $ButtonResetCheckboxes.location                = New-Object System.Drawing.Point($x,$y)
     $ButtonResetCheckboxes.Font                    = 'Microsoft Sans Serif,11'
     $Form.controls.AddRange(@($ButtonResetCheckboxes))
     $ButtonResetCheckboxes.Add_Click({
         Reset-MitreCheckboxes
     })

     $x = $x + $ButtonXDistance

     $ButtonImportYaml                         = New-Object system.Windows.Forms.Button
     $ButtonImportYaml.BackColor               = "#d5d8d7"
     $ButtonImportYaml.text                    = "YAML Admin"
     $ButtonImportYaml.width                   = $ButtonWidth
     $ButtonImportYaml.height                  = $ButtonHeight
     $ButtonImportYaml.location                = New-Object System.Drawing.Point($x,$y)
     $ButtonImportYaml.Font                    = 'Microsoft Sans Serif,11'
     $Form.controls.AddRange(@($ButtonImportYaml))
     $ButtonImportYaml.Add_Click({
        Get-YamlAdminSelect
     })

     $x = $x + $ButtonXDistance

     $ButtonConfig                         = New-Object system.Windows.Forms.Button
     $ButtonConfig.BackColor               = "#C0C0C0"
     $ButtonConfig.text                    = "Configure EventList"
     $ButtonConfig.width                   = $ButtonWidth
     $ButtonConfig.height                  = $ButtonHeight
     $ButtonConfig.location                = New-Object System.Drawing.Point($x,$y)
     $ButtonConfig.Font                    = [System.Drawing.Font]::new("Microsoft Sans Serif", 11, [System.Drawing.FontStyle]::Bold)
     $Form.controls.AddRange(@($ButtonConfig))
     $ButtonConfig.Add_Click({
        Get-EventListConfigSelect
     })

    Sync-ComboBox -ComboBox $ComboBox1 -Items $baselineNames

    $Form.controls.AddRange(@($Panel1,$Panel2))

    [void]$Form.ShowDialog()

}