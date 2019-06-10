function Import-YamlCofigurationFromFolder {

<#
    .SYNOPSIS
    Imports one or more YAML configuration file(s) into the database.

    .DESCRIPTION
    Imports one or more YAML configuration file(s) into the database. YAML configurations can be found in the sigma GitHub repository.

    .PARAMETER Path
    Defines the path where the YAML configuration files are located.

    .PARAMETER Force
    If set, overwrites queries, that were already imported in the database.

    .EXAMPLE
    Import-YamlCofigurationFromFolder -Path "C:\tmp"

    Imports one or more YAML configuration file(s) from "C:\tmp" into the database.

#>

    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [switch]$Force
     )

    $YamlConfigFiles = Get-ChildItem -LiteralPath $Path -Recurse -ErrorAction SilentlyContinue -Force | Group-Object path


    foreach ($item in $YamlConfigFiles.Group) {
        if (![string]::IsNullOrEmpty($item.FullName)) {

            if ($item.Extension -match ".yml") {
                $rawYaml = get-content -raw $item.FullName
                $yamlObj = [pscustomobject](convertfrom-yaml $rawYaml)

                $delQuery = ""
                $tmpStr = ""
                $sqlStr = ""

                $query = "select * from queries_data_yaml_main where title = '" + (ConvertTo-PSSQLString -Text $yamlObj.title) + "';"

                if ($Force) {
                    $m_id = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty "id"

                    if ($m_id -gt 0) {
                        $delQuery = "delete from queries_data_yaml_tags where m_id = '$m_id'; "
                    }

                    $delQuery = $delQuery + "delete from queries_data_yaml_main where title = '" + (ConvertTo-PSSQLString -Text $yamlObj.title) + "';"
                    Invoke-SqliteQuery -Query $delQuery -DataSource $database
                }

                if (!(Invoke-SqliteQuery -Query $query -DataSource $database)) {
                    $sqlStr = "insert into queries_data_yaml_main (title, description, status, date, author, raw_yaml, level, filename) values ('" + (ConvertTo-PSSQLString -Text $yamlObj.title) + "', '" + (ConvertTo-PSSQLString -Text $yamlObj.description) + "', '" + (ConvertTo-PSSQLString -Text $yamlObj.status) + "', '" + (ConvertTo-PSSQLString -Text $yamlObj.date) + "', '" + (ConvertTo-PSSQLString -Text $yamlObj.author) + "', '" + (ConvertTo-PSSQLString -Text $rawYaml) + "', '" + (ConvertTo-PSSQLString -Text $yamlObj.level) + "', '" + (ConvertTo-PSSQLString -Text $item.name) + "'); select last_insert_rowid();"
                    $m_id = Invoke-SqliteQuery -Query $sqlStr -DataSource $database | Select-Object -ExpandProperty "last_insert_rowid()"

                    foreach ($item in $yamlObj.tags) {
                        $technique_id = 0
                        $area_id = 0
                        $tag_category = ($item.split("."))[0]
                        $tag_name = ($item.split("."))[1] -replace "_", " "

                        if ($tag_category -eq "attack") {
                            if ($tag_name.SubString(0,1) -eq "t") {
                                $query = "SELECT * FROM mitre_techniques WHERE technique_id = '$tag_name' COLLATE NOCASE;"
                                $technique_id = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty "id"
                            }
                            else {
                                $query = "SELECT * FROM mitre_areas WHERE area_name = '$tag_name' COLLATE NOCASE;"
                                $area_id = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty "id"

                                if (!($technique_id) -or ($technique_id -eq 0)) {
                                    $query = "SELECT * FROM mitre_techniques WHERE technique_name = '$tag_name' COLLATE NOCASE;"
                                    $technique_id = Invoke-SqliteQuery -Query $query -DataSource $database | Select-Object -ExpandProperty "id"
                                }
                            }
                        }

                        if (!$technique_id) {
                            $technique_id = 0
                        }

                        if (!$area_id) {
                            $area_id = 0
                        }

                        $tmpStr = "insert into queries_data_yaml_tags (tag_name, m_id, full_tag_name, category, mitre_area_id, mitre_technique_id) values ('$tag_name', '$m_id', '$item', '$tag_category', '$area_id', '$technique_id');"

                        if (![string]::IsNullOrEmpty(($tmpStr))) {
                            Invoke-SqliteQuery -Query $tmpStr -DataSource $database
                        }
                    }
                }

            }
        }
    }

}