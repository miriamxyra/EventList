# EventList

![alt text](https://miriamxyra.files.wordpress.com/2019/05/eventlist.png?w=300 "EventList Logo")

EventList is a tool to help improving your Audit capabilities and to help to build your Security Operation Center.

It helps you combining Microsoft Security Baselines with MITRE ATT&CK and generating hunting queries for your SIEM system - regardless of the product used.

## Installation

Install-Module -Name EventList -Force

### PowerShell module dependencies

EventList requires the following PowerShell modules to work properly:
- PSFramework
- PSSQLite
- powershell-yaml

## Usage

Once the module is installed, you can open EventList by calling
    Open-EventListGUI
in powershell.exe as an administrator. The EventList GUI opens.

Important: Do not use powershell_ise.exe to open the GUI, otherwise the resolution might not be at optimum.

## Baselines

There are already some baselines pre-populated in the database.

You can choose a baseline from the drop down menu top left. Once a baseline is chosen, the MITRE ATT&CK checkboxes are being populated. Like this, you can easily check which MITRE ATT&CK techniques and areas are being covered by this particular baseline.

### Importing baselines

Nevertheless, if there are baselines missing, you can import them by using the “Import Baseline(s)” button. Choose the folder where your baseline(s) is/are located to import them. Imports baselines recursively.

Baselines which were already imported into the database won’t be overwritten.

### Deleting baselines

If you want to delete one or more particular baseline(s) from the database, “Delete baseline(s)” will help you doing so. You can either decide if you want to delete the baseline which was selected from the drop down menu or if you want to start over and delete all baselines imported.

## YAML Admin

YAML files are needed when it comes to importing and processing Sigma queries.

You can either import new YAML configuration files or delete them.

### Import YAML configuration files
You can import new YAML configuration files. Already existing configurations won’t be overwritten by using this option. To overwrite YAML configurations, you should delete all existing configurations and import them again.

### Delete YAML configuration files
This option will delete all YAML configurations, that are stored in the EventList database.

## Configure EventList 

### Sigma integration

Prerequisites: Sigma needs to be installed on the client, on which EventList is being used.

To integrate the Sigma framework into EventList, you can use “Configure EventList” to set the path to the Sigma installation.

To configure it successfully, choose the path where sigmac is located (tools/sigmac). If sigmac is not present, the configuration will be discarded.

## Generate EventList

This function provides you with an option to generate a list of the events, that are being generated when either 
	- Applying a certain baseline 
	- Selecting several MITRE ATT&CK techniques/areas

If you check the “generate .csv” checkbox, you can choose an output folder, where your generated file will be located. A .csv Version of the list is being generated.

## Generate Agent configuration 

As you might not want to forward all your generated Event Ids, you can use the “Generate Agent Configuration” to create a configuration snippet that you can just pipe into your agent configuration.

Supported Agents:
	- Splunk

## Generate GPOs

If you want to convert all events, that are being generated for the checked MITRE ATT&CK areas & techniques, into a GPO, use the button “Generate GPOs”.

Hint: if you select an already imported baseline to convert it into a GPO again, there’s a high chance that a different GPO will be generated than the imported. The reason behind that is, that not all events are matched to the MITRE ATT&CK framework, that are being generated by a baseline.

## Generate Queries 

Using the “Generate Queries” button, you can generate hunting queries, matching the selected MITRE ATT&CK areas and techniques.

There are several options to create such a query.

### Sigma queries 

If you want to use Sigma to convert your query into your preferred query language, you can use the option “Please generate SIGMA queries for”.

A drop down is available to choose from all supported SIEM/Hunting systems:

Supported SIEM/Hunting systems:
- Azure Log Analytics
- ArcSight
- ElasticSearch Query Strings
- ElasticSearch Query DSL
- Kibana
- Elastic X-Pack Watcher
- Graylog
- Logpoint
- Grep
- RSA NetWitness
- PowerShell
- QRadar
- Qualys
- Splunk
- Microsoft Defender ATP

### Converting queries directly 
If Sigma is installed and configured for EventList, EventList will automatically use Sigma to parse the queries into the SIEM language of your choice.

Three files will be generated in your output folder:
- EventList-Queries.md
    - This file contains every query which will be successfully converted by Sigma, ordered by MITRE ATT&CK areas & techniques. As it’s formatted using markdown, you can easily copy & paste it into your documentation system of your choice.
- SigmaLog.txt
    - In this file you will find the Output which is being generated by Sigma. If a query isn’t supported by Sigma, you can find the name of the query, including the Sigma output, in here. Like this, you have either the option to build the query manually or to participate in the Sigma project to implement the missing functionality.
- EventList-Queries.txt
    - All generated queries without any documentation or query titles to copy & paste it into your SIEM system. Easy as it.

There will be also a folder generated which is called “yaml”. In this folder you will find all  yaml files, according to the generated queries.

### Converting queries in the backend 

If you have a Sigma backend, there’s also the option to generate the commands to convert the particular yaml files. They are still being sorted by using the MITRE ATT&CK matrix.

If Sigma is not configured (via Configure EventList), this option will be used as default.

Two files are being generated:
- EventList-Queries.md
    - This file contains every command which will be used to convert your YAML files by your Sigma backend, ordered by MITRE ATT&CK areas & techniques. As it’s formatted using markdown, you can easily copy & paste it into your documentation system of your choice.
- EventList-Queries.txt
    - All generated commands to convert your YAML files in your Sigma backend without any documentation or query titles to copy & paste it into your SIEM system.

There will be also a folder generated which is called “yaml”. In this folder you will find all  yaml files, according to the generated queries.

### Generate YAML

If you don’t want to use Sigma at all, there’s still an option to only generate a YAML markdown file:
It is still ordered by the MITRE ATT&CK areas & techniques, but it’s still only the YAML configuration in there. Use it as a hint which events to use for your hunting queries.


Happy hunting!

# EventList Change Log
## 2021-03-21
- Added new event sources: PowerShell Operational Log, WinRM, Windows Defender, Windows PowerShell, PowerShell DSC, Applocker: Packaged app-Deployment, Applocker: MSI and Script, Applocker: EXE and DLL, Applocker: Packaged app-Execution
- Added new columns in events_source: Full Name, Log Path
- Added more event ids to the database: PowerShell
- Changed events_main structure: the PK "id" is no longer treated as the event id of each event. Column "event_id" was added instead. This should avoid conflicts with matching event ids in different event logs