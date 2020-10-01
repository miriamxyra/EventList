function Get-AgentConfigString {

<#
    .SYNOPSIS
    Gets all the event ids that you need to monitor the selected MITRE Techniques & areas.

    .DESCRIPTION
    Gets all the event ids that you need to monitor the selected MITRE Techniques & areas and matches it to the selected event forwarder syntax.

	.PARAMETER ForwarderName
	Specifies the name of the Agent Forwarder for which the config should be queried:
	- splunk
	- xpath
	- mdatp

    .EXAMPLE
    Get-AgentConfigString -ForwarderName splunk

    Gets all the event ids for the Splunk Universal Forwarder that you need to monitor the selected MITRE Techniques & areas.

#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
	[CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('BaselineName', 'TechniqueId')]
		[string]$Identity,
		[Parameter(Mandatory=$True)]
		[string]$ForwarderName
	)

	process {

		if ($Script:openFromGui) {
			$MitreTechniques = $(Get-CheckedMitreTechniques)
		}
		else {
			if ($identity) {
				if (Get-BaselineNameFromDB -BaselineName $Identity){
					$MitreTechniques = Get-MitreTechniquesFromBaseline -BaselineName $Identity
				}
				elseif ($Identity -match "^T\d{4}$") {
					$MitreTechniques = $("'" + $Identity + "'")
				}
				elseif ( ($Identity -match "^['T\d{4}$]") -or ($Identity -match "^T\d{4}$") ) {
					$MitreTechniques = $Identity
				}
			}
		}

		if ($MitreTechniques) {
			if ($Script:openFromGui) {
				$query = "select * from agent_forwarder_syntax where name = '" + (ConvertTo-PSSQLString($ForwarderName)) + "';"
			}
			else {
				$query = "select * from agent_forwarder_syntax where short_name = '" + (ConvertTo-PSSQLString($ForwarderName)) + "';"
			}
			
			$results = Invoke-SqliteQuery -Query $query -DataSource $database
		
			foreach ($result in $results) {
				$eventStr = Get-MitreEvents -MitreTechniques $MitreTechniques -EventIds | Select-Object -ExpandProperty event_id -Unique | foreach-Object { $result.single_event_syntax -replace ("{{SINGLE_EVENTID}}", $_) }
				
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

				if ($Script:openFromGui) {
					$agentSnippetBox.Text = $syntaxStr
				}
				else {
					write-host $syntaxStr
				}
				
			}
		}
		else {
			write-host "No MITRE ATT&CK techniques were selected."
		}
	}

}