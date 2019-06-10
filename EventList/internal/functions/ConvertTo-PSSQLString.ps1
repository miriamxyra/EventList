function ConvertTo-PSSQLString {

<#
    .SYNOPSIS
    Converts a string into a format that can be inserted into a PSSQL database.

    .DESCRIPTION
    Converts a string into a format that can be inserted into a PSSQL database without the risk of common SQL injections.

    .PARAMETER Text
    The String to parse for the database.

    .EXAMPLE
    ConvertTo-PSSQLString -Text $queryString

    Converts a string into a format that can be inserted into a PSSQL database.
#>

	[CmdletBinding()]
	param (
		[string]
		$Text
	)
    $Text = $Text.Replace('"', "&quot;")
    $Text = $Text.Replace("'", "&apos;")
    $Text = $Text.Replace("\x00", "&x00;")
    $Text = $Text.Replace("\n", "&n;")
    $Text = $Text.Replace("\r", "&r;")
    $Text = $Text.Replace("\", "&bsol;")
    $Text = $Text.Replace("\x1a", "&x1a;")
    $Text = $Text.Replace(";", "&#59;")

    return $Text
 }