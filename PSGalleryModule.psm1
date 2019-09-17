Class GalleryInfo {
    $Title
    $Id
    $Type
    $Version
    $PackageDownloadURL
    $NormalizedVersion
    $Owners
    $Authors
    $ProjectUrl
    $CompanyName
    $PackageSize
    $VersionDownloadCount
    $ModuleDownloadCount
    $Description
    $Summary
    $ReleaseNotes
    $Created
    $Published
    $LastUpdated
    $LastEdited
    $IsPrerelease
    $IsAbsoluteLatestVersion
    $IsLatestVersion
    $MinClientVersion
    $Dependecies
    $GalleryDetailsUrl
    $Tags
    $FileList
    $ProcessorArchitecture
    $CLRVersion
    $PowerShellHostVersion
    $DotNetFrameworkVersion
    $PowerShellVersion
    $GUID
    $LicenseReportUrl
    $LicenseNames
    $LicenseUrl
    $Copyright
    $RequireLicenseAcceptance
    $ReportAbuseUrl
    $PackageHashAlgorithm
    $PackageHash
    $raw

    GalleryInfo ($DataInput) {
        $this.raw = $DataInput
        $this.PackageDownloadURL = $DataInput.Content.Src
        $this.Title = $DataInput.Title.'#Text'
        $this.Id = $DataInput.Properties.id
        $this.Version = $DataInput.Properties.Version
        $this.Type = $DataInput.properties.ItemType
        $this.VersionDownloadCount = $DataInput.Properties.VersionDownloadCount.'#Text'
        $this.ModuleDownloadCount = $DataInput.Properties.DownloadCount.'#Text'
        $this.PackageSize = $DataInput.properties.PackageSize.'#Text'
        $this.NormalizedVersion = $DataInput.properties.NormalizedVersion
        $this.Authors = $DataInput.Properties.Authors
        $this.Copyright = $DataInput.Properties.Copyright
        $this.Created = try { get-date $DataInput.properties.Created.'#Text' -ErrorAction stop }catch{$null}
        $this.Description = $DataInput.properties.Description.'#Text'
        $this.Tags = try { $DataInput.properties.tags.split(' ') } catch { $null }
        $this.GalleryDetailsUrl = $DataInput.properties.GalleryDetailsUrl
        $this.FileList = try { $DataInput.properties.FileList.Split('|') } catch { $null }
        $this.Owners = $DataInput.properties.Owners
        $this.CompanyName = $DataInput.properties.CompanyName
        $this.ProcessorArchitecture = $DataInput.properties.ProcessorArchitecture.'#Text'
        $this.CLRVersion = $DataInput.properties.CLRVersion.'#Text'
        $this.PowerShellHostVersion = $DataInput.properties.PowerShellHostVersion.'#Text'
        $this.DotNetFrameworkVersion = $DataInput.properties.DotNetFrameworkVersion.'#Text'
        $this.PowerShellVersion = $DataInput.properties.PowerShellVersion
        $this.GUID = $DataInput.properties.GUID
        $this.LicenseReportUrl = $DataInput.properties.LicenseReportUrl.'#Text'
        $this.LicenseNames = $DataInput.properties.LicenseReportUrl.'#Text'
        $this.LicenseUrl = $DataInput.properties.LicenseUrl
        $this.LastEdited = try { get-date $DataInput.properties.LastEdited.'#Text' -ErrorAction stop }catch{$null}
        $this.MinClientVersion = $DataInput.properties.Summary.'#Text'
        $this.Summary = $DataInput.properties.Summary.'#Text'
        $this.RequireLicenseAcceptance  = [Bool]$DataInput.properties.RequireLicenseAcceptance.'#Text'
        $this.ReleaseNotes = $DataInput.properties.ReleaseNotes.'#Text'
        $this.ReportAbuseUrl  = $DataInput.properties.ReportAbuseUrl
        $this.PackageHashAlgorithm = $DataInput.properties.PackageHashAlgorithm
        $this.PackageHash = $DataInput.properties.PackageHash
        $this.Published = try { get-date $DataInput.properties.Published.'#Text' -ErrorAction stop }catch{$null}
        $this.LastUpdated =  try { get-date $DataInput.properties.LastUpdated.'#Text' -ErrorAction stop }catch{$null}
        $this.IsPrerelease = [bool]$DataInput.properties.IsPrerelease.'#Text'
        $this.IsAbsoluteLatestVersion = [bool]$DataInput.properties.IsAbsoluteLatestVersion.'#Text'
        $this.IsLatestVersion = [bool]$DataInput.properties.IsLatestVersion.'#Text'
        $this.ProjectUrl = If ( [bool]$DataInput.properties.ProjectUrl.null ) {$null}else{$DataInput.properties.ProjectUrl}

    }

    [Object] Download () {
        $PackageName = $this.ID + '.' + $this.NormalizedVersion + '.zip'
        $OutFile = Join-Path -Path $PWD -ChildPath $PackageName

        Invoke-WebRequest -Uri $this.PackageDownloadURL -OutFile $OutFile -ErrorAction Stop
        return (Get-Item -Path $OutFile)
    }

    [Object] Download ($Path) {
        If ( ! ( Test-Path $Path) ) {
            Throw [System.IO.DirectoryNotFoundException]::new("Path Not Found: $Path")
        }
        $PackageName = $this.ID + '.' + $this.NormalizedVersion + '.zip'
        $OutFile = Join-Path -Path $Path -ChildPath $PackageName

        Invoke-WebRequest -Uri $this.PackageDownloadURL -OutFile $OutFile -ErrorAction Stop
        return (Get-Item -Path $OutFile)
    }
}
function Find-GalleryModule {
    <#
    .SYNOPSIS
        Simple Function to retrieve Module(s) info(s) from the PSGallery
    .DESCRIPTION
        Simple Function to retrieve Module(s) info(s) from the PSGallery, and download the module as a zip file.
    .EXAMPLE
        PS C:\> Find-GalleryModule -Module PSClassutils -latestversion
        Will retrieve infos, about all the modules named psclassutils.

        Id                       : PSClassUtils
        Version                  : 2.6.3
        NormalizedVersion        : 2.6.3
        Authors                  : Stéphane van Gulick
        Copyright                : (c) 2018 TAAVAST3. All rights reserved.
        Created                  : Created
        Dependencies             :
        Description              : Contains a set of utilities to work with Powershell Classes
        ...
        DownloadCount            : 240
        VersionDownloadCount     : 1381
    .EXAMPLE
        PS C:\> Find-GalleryModule -Author Stéphane -latestversion
        Will retrieve infos, about all the modules created by authors starting with "Stéphane".

        Id                       : PSClassUtils
        Version                  : 2.6.3
        NormalizedVersion        : 2.6.3
        Authors                  : Stéphane van Gulick
        Copyright                : (c) 2018 TAAVAST3. All rights reserved.
        Created                  : Created
        Dependencies             :
        Description              : Contains a set of utilities to work with Powershell Classes
        ...
    .EXAMPLE
        PS C:\> Find-GalleryModule -Module PSClassutils -latestversion -Download
        Search for module PSClassUtils and download the package as a zip file in the current directory.

        Répertoire : C:\

        Mode                LastWriteTime         Length Name
        ----                -------------         ------ ----
        -a----       04/09/2019     21:51        1854235 PSClassUtils.2.6.3.zip
    .EXAMPLE
        PS C:\> Find-GalleryModule -Date 16/09/2019 -latestversion | select -Property Authors,Title,Version,Published
        will find all published module this day.

        Authors                     Title                     Version  Published          
        -------                     -----                     -------  ---------          
        Przemyslaw Klys            ADEssentials              0.0.18   16/09/2019 21:12:10
        a.krick@outlook.com        AKPT                      5.11.4.0 16/09/2019 07:42:50
        R. Josh Nylander           AMAG-SMSPowershell        1.1.4    16/09/2019 00:38:25
        Esri                       ArcGIS                    2.1.1    16/09/2019 18:45:28
        AzSK Team                  AzSK                      4.1.0    16/09/2019 14:07:54
        AzSK Team                  AzSKPreview               4.1.2    16/09/2019 11:29:40
        David Stein                CMHealthcheck             1.0.10   16/09/2019 23:26:01
        ...
    .EXAMPLE
        PS C:\> Find-GalleryModule -Module p* -LatestVersion -PSEditionType Desktop | select id,version
        Find Modules with id starting with "p", latestversion and are compatible with Powershell Desktop.

        Id                       Version
        --                       -------
        PackageManagement        1.4.4
        PartnerCenter            2.0.1909.2
        PartnerCenter.NetCore    1.5.1908.1
        passwordstate-management 4.0.5
        Pester                   4.9.0
    .INPUTS
        Module(s) Names, or partial Module name
        You can use the * wildcard if you dont know the exact name of the module

        Author Name.

        Date, find all module published at a certain date.
    .OUTPUTS
        Custom [GalleryInfo] Type, representing a Module Infos from the PSGallery
    .NOTES
        Go check: https://github.com/LxLeChat/PSGalleryModule
    #>
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipelineByPropertyName=$True,ValueFromPipeline=$True,ParameterSetName='Module')]
        [Alias("Name")]
        [String[]]$Module,
        [Parameter(ParameterSetName='Author')]
        [String]$Author,
        [Parameter(ParameterSetName='Module')]
        [Parameter(ParameterSetName='Author')]
        [Parameter(ParameterSetName='Date')]
        [Switch]$LatestVersion,
        [ValidateSet("Core","Desktop")]
        [String]$PSEditionType,
        [Parameter(ParameterSetName='Date')]
        [ValidateScript({get-date $_})]
        [String]$Date,
        [Switch]$Download,
        [String]$OutPath
    )
    
    Begin {

        $bQ = '$filter='
        $Q = ''
        $i = 0
        
    }
    
    Process {
        
        Switch ( $PSCmdlet.ParameterSetName ) {

            'Author' {
                ## Build Query, api calls are made in the end block
                $Q = "startswith(Authors,'$Author')"

                If ( $LatestVersion ) {
                    $Q = $Q + ' and IsLatestVersion'
                }

                If ( $PSEditionType ) {
                    Switch ( $PSEditionType ) {
                        "Core"    { $Q = $Q + " and indexof(Tags,'PSEdition_Core') ge 0"}
                        "Desktop" { $Q = $Q + " and indexof(Tags,'PSEdition_Desktop') ge 0"}
                    }
                }
            }

            'Module' {
                ## Build Query, api calls are made in the end block
                Foreach ( $M in $Module ) {
                    
                    If ( $i -gt 0 ) {
                        $Q = $Q + ' or '
                    }

                    switch -Regex ($M) {
                    "^\*.+\*$"  {$tQ = "indexof(Id,'$($M.replace('*',''))') ge 0";break}
                    "^\*.+"     {$tQ = "endswith(Id,'$($M.trimstart('*'))')";break}
                    ".+\*$"     {$tQ = "startswith(Id,'$($M.trimend('*'))')";break}
                    "^\*$"      {$tQ = "startswith(Id,'')";break}
                    default     {$tQ = "Id eq '$M'"}
                    }

                    $Q = $Q + $tQ
                    $i++
                }

                ## Will look for LatestVersion Only
                If ( $LatestVersion ) {
                    $Q = '(' + $Q + ') and IsLatestVersion'
                }

                ## Will look for specific Tags
                If ( $PSEditionType ) {
                    Switch ( $PSEditionType ) {
                        "Core"    { $Q = $Q + " and indexof(Tags,'PSEdition_Core') ge 0"}
                        "Desktop" { $Q = $Q + " and indexof(Tags,'PSEdition_Desktop') ge 0"}
                    }
                }
            }

            'Date' {
                $StartDate = get-date -date $date -Hour 0 -Minute 0 -Second 0 -Format s
                $date1 =  (get-date -Date $date).AddDays(1)
                $EndDate = get-date -date $date1 -Hour 0 -Minute 0 -Second 0 -Format s
                $Q = "Published gt DateTime'$StartDate' and Published lt DateTime'$EndDate'"
                
                ## Will look for LatestVersion Only
                If ( $LatestVersion ) {
                    $Q = $Q + ' and IsLatestVersion'
                }

                ## Will look for specific Tags
                If ( $PSEditionType ) {
                    Switch ( $PSEditionType ) {
                        "Core"    { $Q = $Q + " and indexof(Tags,'PSEdition_Core') ge 0"}
                        "Desktop" { $Q = $Q + " and indexof(Tags,'PSEdition_Desktop') ge 0"}
                    }
                }
            }
        }



    }
    
    End {

        $fQ = $bQ + $Q
        $Uri = "https://www.powershellgallery.com/api/v2/Packages()?$fQ&`$orderby=Id"
        #$Uri
        #break;
        $skip = 0
        $BaseUri = $uri
        $y = 100

        While ( $y -eq 100 ) {

            $y = 0
            ## Build new page 
            If ( $skip -gt 0 ) {
                $uri = $BaseUri + "&`$skip=$skip"
            }
            
            ## ApiCall
            ([Array](Invoke-RestMethod -Method GET -Uri $Uri)).foreach({
                If ( $Download ) {
                    If ( $OutPath ) {
                        [GalleryInfo]::new($_).Download($OutPath)
                    } Else {
                        [GalleryInfo]::new($_).Download()
                    }
                } Else {
                    [GalleryInfo]::new($_)
                }
                
                $y++
            })

            ## Pagination
            If ( $y -eq 100 ) {
                $skip = $skip + $y
            }
        }
        
    }
}
