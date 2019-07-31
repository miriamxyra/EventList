function Get-CheckedMitreTechniques {

<#
    .SYNOPSIS
    Gets all Mitre Techniques that were checked.

    .DESCRIPTION
    Gets all Mitre Techniques that were checked.

    .EXAMPLE
    Get-CheckedMitreTechniques

    Gets all Mitre Techniques that were checked.

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding()]

    foreach ($key in $CheckBox.keys) {

        if (![string]::IsNullOrEmpty($CheckBox[$key].checkedItems)) {
            foreach ($item in ($CheckBox[$key].checkedItems.Split(" ") | Select-String -Pattern 'T[0-9][0-9][0-9][0-9]' -CaseSensitive)) {
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