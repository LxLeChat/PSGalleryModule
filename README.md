# PSModuleInfo
Simple Function to retrieve Module(s) info(s) from the PSGallery.

# How it works
The function builds an odata query for the psgallery api. It uses a basic class to expand all properties.

# Wildcards
You can use the ```*``` wildard if you dont know the exact name of the module.
```
Find-GalleryModule -Module class*
Find-GalleryModule -Module *class
Find-GalleryModule -Module *class*
Find-GalleryModule -Module *
```

## Example
Retrieve all modules named psclassutils. In this example, it will return all the published versions of this particular module.
```
Find-GalleryModule -Module psclassutils
```

Retrieve latestversion of psclassutils modules
Check last 2 properties:

```
Find-GalleryModule -Module Psclassutils -LatestVersion

...
Title                    : Title
Version                  : 2.6.3
DownLoadCount            : 234
VersionDownLoadCount     : 81
```

Retrieve the infos for the latest published version of the psclassutils and adsips modules, and display only the id,version,authors,description
```
Find-GalleryModule -Module 'psclassutils','adsips' -LatestVersion | select id,version,authors,description,versiondownloadcount

Id                   : AdsiPS
Version              : 1.0.0.3
Authors              : Francois-Xavier Cat
Description          : PowerShell module to interact with Active Directory using ADSI and the System.DirectoryServices namespace (.NET Framework)
VersionDownLoadCount : 873

Id                   : PSClassUtils
Version              : 2.6.3
Authors              : Stéphane van Gulick
Description          : Contains a set of utilities to work with Powershell Classes.
VersionDownLoadCount : 85
```

## You can pass module names from the pipeline.
```
'AdsiPS','PSClassutils' | Find-GalleryModule -LatestVersion
```
or
```
Get-Module | Find-GalleryModule -LatestVersion
```

# More infos
-https://github.com/NuGet/Home/wiki/Filter-OData-query-requests

-https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-odata/72d4ebf9-5480-49a4-b88b-c5782f726c87

