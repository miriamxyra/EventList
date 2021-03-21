function Get-MitreEvents {

<#
    .SYNOPSIS
    Returns all events for the selected Mitre techniques.

    .DESCRIPTION
    Returns all events for the selected Mitre techniques.

    .PARAMETER MitreTechniques
	Lets you specify the Mitre ATT&CK techniques that should be used.

    .PARAMETER AdvancedAudit
    If set, only events which will be set from the Advanced Audit options will be taken into account.

	.PARAMETER EventIds
	If set, only Event Ids will be returned from this function.

    .EXAMPLE
    Get-MitreEvents

    Returns all events for the selected Mitre techniques.

#>

	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
	[CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string]$MitreTechniques,
        [switch]$AdvancedAudit,
		[switch]$EventIds
    )

    if (![string]::IsNullOrEmpty($MitreTechniques)) {

        if ($AdvancedAudit){
            # if success_failure_id >= 3 it's always s+f / 1 = s / 2 = f
            $query = "select subcategory_name, guid, sum(success_failure_id) as sf_sum from ( select distinct eaas.subcategory_name, eaas.guid, m.success_failure_id from mitre_techniques t, mitre_events e left join events_main m on e.event_id = em.event_id left join events_source so on m.so_id = so.id left join events_audit_subcategory eas on em.event_id = eas.event_id left join events_advanced_audit_subcategories eaas on eas.audit_subc_id = eaas.id where t.technique_id in ($MitreTechniques) and t.id = e.technique_id and e.event_id is not null and so.source_name = 'Advanced Audit Logs' and e.event_id <> '-1' ) group by subcategory_name, guid order by subcategory_name"
        }
		elseif ($EventIds) {
            $query = "select distinct e.event_id from mitre_techniques t, mitre_events e left join events_main m on e.event_id = em.event_id left join events_source so on m.so_id = so.id left join events_security_recommendation sr on m.sr_id = sr.id where t.technique_id in ($MitreTechniques) and t.id = e.technique_id and e.event_id is not null order by e.event_id"
        }
        else {
            $query = "select t.technique_id, t.technique_name, e.event_id, m.event_name, m.link_text, so.source_name, sr.sec_rec_name from mitre_techniques t, mitre_events e left join events_main m on e.event_id = em.event_id left join events_source so on m.so_id = so.id left join events_security_recommendation sr on m.sr_id = sr.id where t.technique_id in ($MitreTechniques) and t.id = e.technique_id and e.event_id is not null order by e.event_id"
        }

        $resultStr = Invoke-SqliteQuery -Query $query -DataSource $database
    }

    return $resultStr
}