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
        if (![string]::IsNullOrEmpty($CheckBoxArea[$key].checkedItems)) {
            foreach ($item in ($CheckBoxArea[$key].checkedItems.Split(" "))) {
                if (![string]::IsNullOrEmpty($item)) {
                    if ([string]::IsNullOrEmpty($tmpStr)) {
                        $tmpStr = "'$item'"
                    }
                    else {
                        $tmpStr = "$tmpStr, '$item'"
                    }

                }
            }
        }
    }

    return $tmpStr
}