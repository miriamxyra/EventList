function Add-EventListConfiguration {

<#
    .SYNOPSIS
    Writes an EventList configuration to the database.

    .DESCRIPTION
    Writes an EventList configuration to the database. Important: Specify the sigma\tools folder!

    Configurable options:
      - Path where Sigma is located to automatically parse the desired queries.
      - Default Output Path: Avoid clicking 1000 times to specify a default output location.

    .PARAMETER sigmaPath
    Path where Sigma is located to automatically parse the desired queries.

    .PARAMETER defaultOutputPath
    Default Output Path: Avoid clicking 1000 times to specify a default output location.

    .EXAMPLE
    Add-EventListConfiguration -sigmaPath "C:\tmp\sigma\tools"

    Writes the configuration for the Sigma Path to the database.

#>

    param(
        [string]$sigmaPath
    )

    if ($sigmaPath) {
        $query = "Update EventList_configuration set sigma_path='" + $sigmaPath + "' where id=1;"
    }

    if ($query) {
        Invoke-SqliteQuery -Query $query -DataSource $database
    }
}