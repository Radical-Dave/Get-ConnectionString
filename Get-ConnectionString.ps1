#Set-StrictMode -Version Latest
#####################################################
# Get-ConnectionString
#####################################################
<#PSScriptInfo

.VERSION 0.4

.GUID 602bc07e-a621-4738-8c27-0edf4a4cea8e

.AUTHOR David Walker, Sitecore Dave, Radical Dave

.COMPANYNAME David Walker, Sitecore Dave, Radical Dave

.COPYRIGHT David Walker, Sitecore Dave, Radical Dave

.TAGS sitecore powershell local install iis solr

.LICENSEURI https://github.com/Radical-Dave/Get-ConnectionString/blob/main/LICENSE

.PROJECTURI https://github.com/Radical-Dave/Get-ConnectionString

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


#>

<#
.SYNOPSIS
PowerShell Script helper for getting ConnectionString from config, etc.

.DESCRIPTION
PowerShell Script helper for getting ConnectionString from config, etc.

.EXAMPLE
PS> Get-ConnectionString

.EXAMPLE
PS> Get-ConnectionString -database logs

.EXAMPLE
PS> Get-ConnectionString . default

.EXAMPLE
PS> Get-ConnectionString c:\inetpub\wwwroot\yoursite master

.EXAMPLE
PS> Get-ConnectionString appconfig? default

.Link
https://github.com/Radical-Dave/Get-ConnectionString

.OUTPUTS
    System.String
#>
[CmdletBinding(SupportsShouldProcess=$true)]
Param(
	[Parameter(Mandatory = $false, Position=0)]
	[string] $path,
	[Parameter(Mandatory = $false, Position=1)]
	[string] $name = '',
	[Parameter(Mandatory = $false, Position=2)]
	[string] $database = '.',
	[Parameter(Mandatory = $false, Position=3)]
	[string] $default = 'Data Source=.;Initial Catalog=.;Integrated Security=SSPI;'
)
begin {
	$PSScriptName = ($MyInvocation.MyCommand.Name.Replace(".ps1",""))
	$PSScriptVersion = (Test-ScriptFileInfo -Path $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty Version)
	$PSCallingScript = $MyInvocation.PSCommandPath ? ($MyInvocation.PSCommandPath | Split-Path -Parent) : ''
	Write-Verbose "#####################################################"
	Write-Verbose "# $PSScriptRoot/$PSScriptName $($PSScriptVersion):$path $name $($PSCallingScript -eq '' ? '' : ' called by:')$PSCallingScript"
}
process {
	try {
		if (!$path -or $path -eq '.') {$path = Get-Location}
		if($PSCmdlet.ShouldProcess($path)) {
			$configPath = $path
			if ($configPath) {
				if (!(Test-Path $configPath -PathType Leaf)) { $configPath = "$path/app_config/connectionstrings.config" }
				if (!(Test-Path $configPath)) { throw "ERROR $PSScriptName - invalid path:$path"}
				Write-Verbose "configPath:$configPath"
				#$connectionStrings = (Get-Content $webConfig) -as [Xml]
				[XML]$connectionStrings = Get-Content ($configPath)
				if ($connectionStrings) {
					#$connectionString = $connectionStrings.connectionStrings.add | Where-Object name -eq $name
					$connectionString = $connectionStrings.connectionStrings.SelectSingleNode("add[@name='" + $name + "']")
					$results = $connectionString.connectionString
				}
			}
		}
	}
	catch {
		throw "ERROR $PSScriptName - $_"
	}
}
end {
	if (!$results -and $default) {
		$results = $default
		if ($database -ne '.') {$results = $results.Replace('Catalog=.',"Catalog=$database")}
	}
	return $results
}