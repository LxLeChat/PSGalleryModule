Class GalleryInfo {
    $Title
    $Id
    $Type
    $Version
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
}
function Find-GalleryModule {
    <#
    .SYNOPSIS
        Simple Function to retrieve Module(s) info(s) from the PSGallery
    .DESCRIPTION
        Simple Function to retrieve Module(s) info(s) from the PSGallery
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
    .INPUTS
        Module(s) Names, or partial Module name
        You can use the * wildcard if you dont know the exact name of the module
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
        [Switch]$LatestVersion
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
                    $Q = '(' + $Q + ' and IsLatestVersion)'
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

                    If ( $LatestVersion ) {
                        $tQ = '(' + $tQ + ' and IsLatestVersion)'
                    }

                    $Q = $Q + $tQ
                    $i++
                }
            }
        }



    }
    
    End {

        $fQ = $bQ + $Q
        $Uri = "https://www.powershellgallery.com/api/v2/Packages()?$fQ&`$orderby=Id"
        $Uri
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
                [GalleryInfo]::new($_)
                $y++
            })
            $y

            ## Pagination
            If ( $y -eq 100 ) {
                $skip = $skip + $y
            }
        }
        
    }
}
