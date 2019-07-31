function Sync-ComboBox
{
<#
    .SYNOPSIS
        This functions helps you load baselines into a ComboBox.

    .DESCRIPTION
        Use this function to dynamically load baselines into the ComboBox control.

    .PARAMETER  ComboBox
        The ComboBox control you want to add items to.

    .PARAMETER  Items
        The object or objects you wish to load into the ComboBox's Items collection.

    .PARAMETER  DisplayMember
        Indicates the property to display for the items in this control.

    .PARAMETER  Append
        Adds the item(s) to the ComboBox without clearing the Items collection.

    .EXAMPLE
        Sync-ComboBox -ComboBox $ComboBox1 -Items $baselineNames

#>
	[CmdletBinding()]
	Param (
			[ValidateNotNull()]
			[Parameter(Mandatory=$true)]
			[System.Windows.Forms.ComboBox]$ComboBox,
			$Items,
			[string]$DisplayMember,
			[switch]$Append
		)

   if(-not$Append)
    {
        $ComboBox.Items.Clear()
        $ComboBox.text = "No Baselines imported"
    }

    if($Items-is [Object[]])
    {
        $ComboBox.Items.AddRange($Items)
        $ComboBox.text = "Select Baseline"
    }
    elseif ($Items-is [Array])
    {
        $ComboBox.BeginUpdate()
        foreach($obj in $Items)
        {
            $ComboBox.Items.Add($obj)
            $ComboBox.text = "Select Baseline"
        }
        $ComboBox.EndUpdate()
    }
    elseif (![string]::IsNullOrEmpty($Items))
    {
        $ComboBox.Items.Add($Items)
        $ComboBox.text = "Select Baseline"
    }

    $ComboBox.DisplayMember =$DisplayMember
}