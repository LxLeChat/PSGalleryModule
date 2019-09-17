# PSMGalleryModule
Simple Function to retrieve Module(s) info(s) from the PSGallery. Its an attempt to search the psgallery with it's API.
The idea at the begining was to be able to retrieve module download infos.

# How it works
The function builds an odata query for the psgallery api. It uses a basic class to expand all properties and give the possibility to download the package.

# Install
Fork the projet and clone it, or install from the psgallery directly : ```Install-Module PSGalleryModule``` 

# Search Options
You can search by Module Name, by Authors, or by Date.
```powershell
Find-GalleryModule -Module Pshtml* -LatestVersion
Find-GalleryModule -Author Lxlechat -LatestVersion
Find-GalleryModule -Date 17/09/2019 -LatestVersion
```
You can not use the ```author```, ```module``` or ```date``` parameter at the same time.

# Download
You can use the ```Download``` switch to download the package as a ```zip``` file.
By default the package will be downloaded in the current directory. To change this behavior, use the ```outpath``` parameter.

As the files are saved as zip files, you can directly pipe the result to ```Expand-Archive```.
```powershell
Find-GalleryModule -Module PSClassUtils -DownLoad | Expand-Archive
```

# Wildcards
You can use the ```*``` wildard if you dont know the exact name of the module.
```powershell
Find-GalleryModule -Module class*
Find-GalleryModule -Module *class
Find-GalleryModule -Module *class*
Find-GalleryModule -Module *
```

## Examples
Retrieve all modules named psclassutils. In this example, it will return all the published versions of this particular module.
```powershell
Find-GalleryModule -Module psclassutils
```

Retrieve latestversion of psclassutils modules
Check last 2 properties:

```powershell
Find-GalleryModule -Module Psclassutils -LatestVersion

...
Title                    : Title
Version                  : 2.6.3
DownLoadCount            : 234
VersionDownLoadCount     : 81
```

Retrieve the infos for the latest published version of the psclassutils and adsips modules, and display only the id,version,authors,description
```powershell
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

Retrieve the infos for the latest module created by the authors wich start with ```Jérôme``` 
```powershell
Find-GalleryModule -Author Jérôme -LatestVersion | Select Authors,Id

Authors             Id
-------             --
Jérôme Bezet-Torres ENILog
Jérôme Bezet-Torres FreeNas
Jérôme Bezet-Torres UpdatePwshModule
```

Download the latest module created by the authors wich start with ```Damien``` 
```powershell
Find-GalleryModule -Author Damien -LatestVersion -OutPath c:\temp

    Répertoire : C:\temp


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       04/09/2019     17:12          15439 comparecomputer.1.0.0.zip
-a----       04/09/2019     17:12           9278 ConfigExport.1.0.0.1.zip
-a----       04/09/2019     17:12           5173 GetBIOS.1.2.0.zip
-a----       04/09/2019     17:12         762749 MDTMonitor.1.0.0.zip
-a----       04/09/2019     17:12           6412 PS1ToEXE.1.0.0.1.zip
-a----       04/09/2019     17:12           6035 PSTalk.1.0.0.zip
-a----       04/09/2019     17:12           7563 SetBIOS.1.0.0.zip
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

