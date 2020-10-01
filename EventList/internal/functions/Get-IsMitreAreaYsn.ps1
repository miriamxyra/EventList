function Get-IsMitreAreaYsn {

    <#
        .SYNOPSIS
        Returns if a string is a MitreArea.
    
        .DESCRIPTION
        Returns if a string is a MitreArea.
    
        .EXAMPLE
        Get-IsMitreAreaYsn -BaselineName "MSFT Windows Server 2019 - Domain Controller"
    
        Returns all Mitre Techniques that would be covered by the specified baseline.
    
    #>
        [CmdletBinding()]
        [OutputType([Bool])]
        param (
            [Parameter(Mandatory = $true)]
            [string]$AreaName
        )
    
        $query = "select area_name from mitre_areas where area_name = ' + $AreaName + ';"
    
        if (Invoke-SqliteQuery -Query $query -DataSource $database) {
            return $true
        }
        else {
            return $false
        }

        
    
    }