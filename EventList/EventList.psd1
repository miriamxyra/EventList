﻿@{
	# Script module or binary module file associated with this manifest
	ModuleToProcess = 'EventList.psm1'

	# Version number of this module.
	ModuleVersion = '2.0.2'

	# ID used to uniquely identify this module
	GUID = '6a7ec113-3459-431c-a0eb-4942615a850c'

	# Author of this module
	Author = 'Miriam Wiesner'

	# Company or vendor of this module
	CompanyName = 'Miriam Wiesner'

	# Copyright statement for this module
	Copyright = 'Copyright (c) 2019 Miriam Wiesner'

	# Description of the functionality provided by this module
	Description = 'EventList - The Event Analyzer. This tool helps you to decide which events to monitor in your infrastructure and supports you doing so.'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'; ModuleVersion='1.4.150' }
		@{ ModuleName = 'PSSQLite'; ModuleVersion = '1.1.0' }
		@{ ModuleName = 'powershell-yaml'; ModuleVersion = '0.4.2' }
	)

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\EventList.dll')

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\EventList.Types.ps1xml')

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\EventList.Format.ps1xml')

	# Functions to export from this module
	FunctionsToExport = @(
		'Open-EventListGUI'
		'Import-BaselineFromFolder'
		'Get-BaselineNameFromDB'
		'Remove-AllBaselines'
		'Remove-OneBaseline'
		'Get-BaselineEventList'
		'Get-MitreEventList'
		'Get-AgentConfigString'
		'Get-SigmaSupportedSiemFromDb'
		'Get-GroupPolicyFromMitreTechniques'
		'Import-YamlCofigurationFromFolder'
		'Remove-AllYamlConfigurations'
		'Add-EventListConfiguration'
		'Get-SigmaPath'
		'Get-SigmaQueries'
		'Remove-EventListConfiguration'
	)

	# Cmdlets to export from this module
	CmdletsToExport = ''

	# Variables to export from this module
	VariablesToExport = ''

	# Aliases to export from this module
	AliasesToExport = ''

	# List of all modules packaged with this module
	ModuleList = @()

	# List of all files packaged with this module
	FileList = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		#Support for PowerShellGet galleries.
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @("Mitre_ATT&CK", "Mitre", "Windows_Events", "Event_ID", "EventList", "Event_List")

			# A URL to the license for this module.
			LicenseUri = 'https://opensource.org/licenses/MIT'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/miriamxyra/EventList'

			# A URL to an icon representing this module.
			IconUri = 'https://miriamxyra.files.wordpress.com/2019/05/eventlist.png'

			# ReleaseNotes of this module
			# ReleaseNotes = ''

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}
