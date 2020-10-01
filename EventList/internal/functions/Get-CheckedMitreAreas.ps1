function Get-CheckedMitreAreas {

<#
    .SYNOPSIS
    Gets all Mitre Areas that were checked.

    .DESCRIPTION
    Gets all Mitre Areas that were checked.

    .EXAMPLE
    Get-CheckedMitreAreas

    Gets all Mitre Areas that were checked.

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding()]
	param ()

    foreach ($key in $CheckBoxArea.keys) {
        #write-host "lol: " $CheckBoxArea[$key].checkedItems
        if (![string]::IsNullOrEmpty($CheckBoxArea[$key].checkedItems)) {
            #write-host "yay1"
            foreach ($item in ($CheckBoxArea[$key].checkedItems.Split(" "))) {
                #write-host "yay2"
                if (![string]::IsNullOrEmpty($item)) {
                    #write-host "yay3"
                    if ([string]::IsNullOrEmpty($tmpStr)) {
                        #write-host "yay4.1"
                        $tmpStr = "'$item'"
                    }
                    else {
                        $tmpStr = "$tmpStr, '$item'"
                        #write-host "yay4.2"
                    }

                }
            }
        }
    }

    #write-host $tmpStr
    return $tmpStr
}