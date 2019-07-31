function Import-YamlCofigurationFiles {

<#
    .SYNOPSIS
    Imports one or more YAML configuration file(s) from a folder into the database.

    .DESCRIPTION
    Imports one or more YAML configuration file(s) from a folder into the database. YAML configurations can be found in the sigma GitHub repository.

    .EXAMPLE
    Import-YamlCofigurationFiles

    Imports one or more YAML configuration file(s) from a folder into the database.

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]

    $configFolder = Start-FilePicker -description "Select the directory where the YAML configuration files are located"
    if (![string]::IsNullOrEmpty($configFolder)) {
        Import-YamlCofigurationFromFolder -Path $configFolder
    }
    else {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("No Folder was selected.",0,"Done",0x1)
    }

}