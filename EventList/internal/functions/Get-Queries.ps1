function Get-Queries {

<#
    .SYNOPSIS
    Returns queries for the selected MITRE ATT&CK Techniques & areas.

    .DESCRIPTION
    Returns queries for the selected MITRE ATT&CK Techniques & areas.

    .PARAMETER TechniqueIds
	Prompts you for the TechniqueIds which should be used to generate the queries.

    .PARAMETER AreaNames
	    Prompts you for the Area Names which should be used to generate the queries.

    .EXAMPLE
    Get-Queries -TechniqueIds "'T1086', 'T1039', 'T1090'" -AreaNames ""

    Returns queries for the selected MITRE ATT&CK Techniques & areas.

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding()]
	param (
        [Parameter(Mandatory=$True)]
        [string]$TechniqueIds,
        [string]$AreaNames
    )

    $query = "select distinct
                ma.area_name, mt.technique_id, mt.technique_name, qm.title, qm.description, qm.status, qm.date, qm.author, qm.raw_yaml, qm.level, qm.filename
            from mitre_events me, mitre_techniques mt, mitre_areas ma,
            queries_data_yaml_tags qt,
            queries_data_yaml_main qm
            where me.technique_id = mt.id
            and qt.mitre_technique_id = mt.id
            and qt.m_id = qm.id
            and me.area_id = ma.id
            and (
                    (mt.technique_id in ($TechniqueIds) )
                    or (ma.area_name in ($AreaNames))
                )
            order by area_id, technique_name;"


    $result = Invoke-SqliteQuery -Query $query -DataSource $database

    return $result
}