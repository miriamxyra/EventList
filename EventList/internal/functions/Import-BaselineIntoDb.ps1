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

    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
		[string]$PolicyName
    )

    $Query = "select name from baseline_main where name = '$PolicyName';"

    if (!(Invoke-SqliteQuery -Query $Query -DataSource $Database)){
        $settings = Import-Csv -Path $Path

        if ($settings) {
            $Query = "insert into baseline_main (name) values ('$PolicyName');SELECT last_insert_rowid();"
            $b_id = Invoke-SqliteQuery -Query $Query -DataSource $Database | Select-Object -ExpandProperty "last_insert_rowid()"

            ForEach ($setting in $settings){
                $policy_target = $($setting."Policy Target")
                $subcategory = $($setting."Subcategory")
                $subcategory_guid = $($setting."Subcategory GUID")
                $inclusion_setting = $($setting."Inclusion Setting")
                $exclusion_setting = $($setting."Exclusion Setting")
                $setting_value = $($setting."Setting Value")

                $Query = "insert into baseline_data (policy_target,subcategory,subcategory_guid,inclusion_setting,exclusion_setting,setting_value,b_id) values ('$policy_target','$subcategory','$subcategory_guid','$inclusion_setting','$exclusion_setting','$setting_value','$b_id');"
                Invoke-SqliteQuery -Query $Query -DataSource $Database
            }
        }
    }
    else {
        $wshell = New-Object -ComObject Wscript.Shell
        $wshell.Popup("Baseline $PolicyName was already imported",0,"Done",0x1)
    }




}