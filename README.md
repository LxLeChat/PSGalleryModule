# PSGModuleInfo
Simple Function to retrieve Module(s) info(s) from the PSGallery

# How it works
The function builds an odata query for the psgallery api.

# Wildcard
You can use the asterisk wildard if you dont know the exact name of the module
Get-PSGModuleInfo -Module 'PSC*'
It will retrieve all module where the module id starts with PSC

## Example
Get-PSGModuleInfo -Module 'psclassutils' -LatestVersion | select id,version,authors,description,@{l='DllCount';e={$_.downloadcount.'#text'}}

```
Id          : PSClassUtils
Version     : 2.6.3
Authors     : Stéphane van Gulick
Description : Contains a set of utilities to work with Powershell Classes.
DllCount    : 230
```

Get-PSGModuleInfo -Module 'psclassutils','adsips' -LatestVersion | select id,version,authors,description,@{l='DllCount';e={$_.downloadcount.'#text'}}

```
Id          : AdsiPS
Version     : 1.0.0.3
Authors     : Francois-Xavier Cat
Description : PowerShell module to interact with Active Directory using ADSI and the System.DirectoryServices namespace (.NET Framework)
DllCount    : 1374

Id          : PSClassUtils
Version     : 2.6.3
Authors     : Stéphane van Gulick
Description : Contains a set of utilities to work with Powershell Classes.
DllCount    : 230
```

'AdsiPS','PSClassutils' | Get-PSGModuleInfo -LatestVersion

## More infos
https://github.com/NuGet/Home/wiki/Filter-OData-query-requests
