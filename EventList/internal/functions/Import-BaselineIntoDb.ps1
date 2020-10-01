function Import-BaselineIntoDb {

<#
    .SYNOPSIS
    Imports one policy into the database, if not existant yet.

    .DESCRIPTION
    Imports one policy into the database, if not existant yet.

    .PARAMETER Path
    Defines the path where the baseline is located.

    .PARAMETER PolicyName
    Name of the baseline which should be imported.

    .EXAMPLE
    Import-BaselineIntoDb -Path $item.FullName -PolicyName $auditPolicyNameStr

    Imports one policy into the database, if not existant yet.

#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
		[string]$PolicyName
    )

    $PolicyName = ConvertTo-PSSQLString($PolicyName)

    $Query = "select name from baseline_main where name = '$PolicyName';"

    if (!(Invoke-SqliteQuery -Query $Query -DataSource $Database)){
        $settings = Import-Csv -Path $Path

        if ($settings) {
            $Query = "insert into baseline_main (name) values ('$PolicyName');SELECT last_insert_rowid();"
            $b_id = Invoke-SqliteQuery -Query $Query -DataSource $Database | Select-Object -ExpandProperty "last_insert_rowid()"

            ForEach ($setting in $settings){
                $policy_target = $PolicyName = ConvertTo-PSSQLString($($setting."Policy Target"))
                $subcategory = ConvertTo-PSSQLString($($setting."Subcategory"))
                $subcategory_guid = ConvertTo-PSSQLString($($setting."Subcategory GUID"))
                $inclusion_setting = ConvertTo-PSSQLString($($setting."Inclusion Setting"))
                $exclusion_setting = ConvertTo-PSSQLString($($setting."Exclusion Setting"))
                $setting_value = ConvertTo-PSSQLString($($setting."Setting Value"))

                $Query = "insert into baseline_data (policy_target,subcategory,subcategory_guid,inclusion_setting,exclusion_setting,setting_value,b_id) values ('$policy_target','$subcategory','$subcategory_guid','$inclusion_setting','$exclusion_setting','$setting_value','$b_id');"
                Invoke-SqliteQuery -Query $Query -DataSource $Database
            }
        }
    }
    else {
        $PolicyName = ConvertFrom-PSSQLString($PolicyName)
        $resultStr = "Baseline $PolicyName was already imported"
        if ($Script:openFromGui) {
            $wshell = New-Object -ComObject Wscript.Shell
            $wshell.Popup($resultStr,0,"Done",0x1)
        }
        else {
            write-host $resultStr
        }
    }




}