function Get-AgentConfigString {

<#
    .SYNOPSIS
    Gets all the event ids that you need to monitor the selected MITRE Techniques & areas.

    .DESCRIPTION
    Gets all the event ids that you need to monitor the selected MITRE Techniques & areas and matches it to the selected event forwarder syntax.

	.PARAMETER ForwarderName
	Specifies the name of the Agent Forwarder for which the config should be queried.

    .EXAMPLE
    Get-AgentConfigString -ForwarderName "Splunk Universal Forwarder"

    Gets all the event ids for the Splunk Universal Forwarder that you need to monitor the selected MITRE Techniques & areas.

#>

	[CmdletBinding()]
    param (
        [string]$ForwarderName
    )

	$query = "select * from agent_forwarder_syntax where name = '" + (ConvertTo-PSSQLString($ForwarderName)) + "';"
	$results = Invoke-SqliteQuery -Query $query -DataSource $database

	foreach ($result in $results) {
		$eventStr = Get-MitreEvents -EventIds | Select-Object -ExpandProperty event_id -Unique | foreach-Object { $result.single_event_syntax -replace ("{{SINGLE_EVENTID}}", $_) }
		
		$eventStr = [string]$eventStr -replace(" ", ($result.event_separator + " "))
		$eventStr = [string]$eventStr -replace(($result.event_separator + " -1"), "")

		if ($result.single_event_syntax -eq "{{SINGLE_EVENTID}}") {
			$eventStr = [string]$eventStr -replace("-1", "")
		}
		else {
			$SingleEventSyntaxReplaced = $result.single_event_syntax -replace ("{{SINGLE_EVENTID}}", "")
			$eventStr = [string]$eventStr -replace(($SingleEventSyntaxReplaced + "-1" + $result.event_separator), "")
		}

		$syntaxStr = $result.syntax -replace ("{{EVENTIDS}}", $eventStr) -replace "`n", "`r`n"

		$syntaxStr = $syntaxStr -replace(("= " + $result.event_separator), "=")
		$agentSnippetBox.Text = $syntaxStr
		
	}

}