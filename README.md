# Get-ConnectionString
## Description
PowerShell Script helper for getting ConnectionString from config, etc.

## Installation (Powered by [PowerShellGallery](https://powershellgallery.com/packages/Get-ConnectionString))
PS> Install-Script Get-ConnectionString

## Example
PS> Get-ConnectionString - creates a default connection string: 'Data Source=.;Initial Catalog=.;Integrated Security=SSPI;'

PS> Get-ConnectionString c:\inetpub\wwwroot\yoursite default - returns connectionstring named core from [yoursite]/app_config/connectionstrings.config

## Copyright
David Walker, Radical Dave, Sitecore Dave
MIT License: https://github.com/Radical-Dave/Get-ConnectionString/blob/main/LICENSE
