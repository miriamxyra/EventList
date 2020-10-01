function Get-MitreTechniquesFromBaseline {

    <#
        .SYNOPSIS
        Returns a list of MitreTechniques that would be covered by a specific baseline.
    
        .DESCRIPTION
        Returns a list of MitreTechniques that would be covered by a specific baseline.
    
        .EXAMPLE
        Get-MitreTechniquesFromBaseline -BaselineName "MSFT Windows Server 2019 - Domain Controller"
    
        Returns all Mitre Techniques that would be covered by the specified baseline.
    
    #>
        [CmdletBinding()]
        [OutputType([String])]
        param (
            [Parameter(Mandatory = $true)]
            [string]$BaselineName
        )
    
        $query = "select distinct a.technique_id as technique_id from ( select * from v_mitre_matches_baseline ) a left join ( select * from v_mitre_matches_baseline where baseline_name = '$BaselineName' ) b on a.technique_id = b.technique_id where b.baseline_name is not null order by a.area_id, a.technique_name;"
    
        $MitreTechniques = "'" + ((Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty technique_id) -join "', '") + "'"

        return $MitreTechniques
    
    }