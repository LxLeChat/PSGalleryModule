# PSGModuleInfo
Simple Function to retrieve Module(s) info(s) in the PSGallery

# How it works
The function builds an odata query for the psgallery api.


## Example
Get-PSGModuleInfo -Module 'psc*' -LatestVersion | select id,version,authors,description,@{l='DllCount';e={$_.downloadcount.'#text'}}

## More infos
https://github.com/NuGet/Home/wiki/Filter-OData-query-requests
