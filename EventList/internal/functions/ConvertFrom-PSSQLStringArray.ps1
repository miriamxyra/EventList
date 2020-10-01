function ConvertFrom-PSSQLStringArray {

<#
    .SYNOPSIS
    Converts a text string from a database into output text.

    .DESCRIPTION
    Converts a text string from a database into output text, which was earlier parsed by the ConvertTo-PSSQLString function.

    .PARAMETER Text
    The String to parse for Output.

    .EXAMPLE
    ConvertFrom-PSSQLStringArray -Text $queryString

    Converts a text string from a database into output text.

#>

	[CmdletBinding()]
	[OutputType([String])]
	param (
		[string[]]$Text
	)
    $Text = $Text.Replace("&quot;", '"')
    $Text = $Text.Replace("&apos;", "'")
    $Text = $Text.Replace("&x00;", "\x00")
    $Text = $Text.Replace("&n;", "\n")
    $Text = $Text.Replace("&r;", "\r")
    $Text = $Text.Replace("&bsol;", "\")
    $Text = $Text.Replace("&x1a;", "\x1a")
    $Text = $Text.Replace("&#59;", ";")

    return $Text
 }