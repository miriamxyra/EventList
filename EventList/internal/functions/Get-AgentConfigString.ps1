function Get-AgentConfigString {

<#
    .SYNOPSIS
    Gets all the event ids that you need to monitor the selected MITRE Techniques & areas.

    .DESCRIPTION
    Gets all the event ids that you need to monitor the selected MITRE Techniques & areas and matches it to the selected event forwarder syntax.

    .EXAMPLE
    Get-AgentConfigString -ForwarderName "Splunk Universal Forwarder"

    Gets all the event ids for the Splunk Universal Forwarder that you need to monitor the selected MITRE Techniques & areas.

#>

    param (
        [string]$ForwarderName
    )

    $query = "select syntax from agent_forwarder_syntax where name = '" + (ConvertTo-PSSQLString($ForwarderName)) + "';"
    $syntaxStr = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty syntax

    $eventStr = Get-MitreEvents | Select-Object -ExpandProperty event_id -Unique

    $eventStr = [string]$eventStr -replace(" ", ", ")
    $eventStr = [string]$eventStr -replace(", -1", "")
    $eventStr = [string]$eventStr -replace("-1", "")

    $syntaxStr = $syntaxStr -replace ("{{EVENTIDS}}", $eventStr) -replace "`n", "`r`n"

    $syntaxStr = $syntaxStr -replace("= ,", "=")

    $agentSnippetBox.Text = $syntaxStr

}