function Close-Form {

<#
    .SYNOPSIS
    Closes the Form.

    .DESCRIPTION
    Closes the Form, that was passed by the -Form Parameter. Nothing to see here, move on! ;-)

    .PARAMETER Form
    A Windows form that should be closed: [system.Windows.Forms.Form]

    .EXAMPLE
    Close-Form -Form $Form

    Closes the Form.

#>
	[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
		[object]$Form
    )
    $Form.close()
}