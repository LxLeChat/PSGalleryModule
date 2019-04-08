function Get-PSGModuleInfo {
    <#
    .SYNOPSIS
        Simple Function to retrieve Module(s) info(s) from the PSGallery
    .DESCRIPTION
       Simple Function to retrieve Module(s) info(s) from the PSGallery
    .EXAMPLE
        PS C:\> Get-PSGModuleInfo -Module PSClassutils
        Will retrieve infos, about all the modules named psclassutils.

        Id                       : PSClassUtils
        Version                  : 0.10.0
        NormalizedVersion        : 0.10.0
        Authors                  : Stéphane van Gulick
        Copyright                : (c) 2018 TAAVAST3. All rights reserved.
        Created                  : Created
        Dependencies             :
        Description              : Contains a set of utilities to work with Powershell Classes.
        DownloadCount            : DownloadCount
        GalleryDetailsUrl        : https://www.powershellgallery.com/packages/PSClassUtils/0.10.0
        IconUrl                  : IconUrl
        IsLatestVersion          : IsLatestVersion
        IsAbsoluteLatestVersion  : IsAbsoluteLatestVersion
        IsPrerelease             : IsPrerelease
        Language                 : Language
        LastUpdated              : LastUpdated
        Published                : Published
        PackageHash              : gENnbohfT7my02tp4IFsvw1qKQDzX1NJWB4lOa1+AtCLmrQZBcn86xFtYJQcQD7drV9jRXIiY3QZ6yIPVZyeBA==
        PackageHashAlgorithm     : SHA512
        PackageSize              : PackageSize
        ProjectUrl               : ProjectUrl
        ReportAbuseUrl           : https://www.powershellgallery.com/packages/PSClassUtils/0.10.0/ReportAbuse
        ReleaseNotes             : ReleaseNotes
        RequireLicenseAcceptance : RequireLicenseAcceptance
        Summary                  : Summary
        Tags                     : PSModule
        Title                    : Title
        VersionDownloadCount     : VersionDownloadCount
    .INPUTS
        Module(s) Names, or partial Module name
        You can use the wildcard if you dont know the exact name of the module
    .OUTPUTS
        Module(s) Info(s) from the PSGallery
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)][String[]]$Module,
        [Switch]$LatestVersion
    )
    
    Begin {

        $bQ = '$filter='
        $Q = ''
        $i = 0
        
    }
    
    Process {

        Foreach ( $M in $Module ) {
            
            If ( $i -gt 0 ) {
                If ( $LatestVersion) {
                    $Q = $Q + ') or '
                } Else {
                    $Q = $Q + ' or '
                }
                
            }


            If ( $M -match '\*$') {

                If ( $LatestVersion ) {
                    $Q = $Q + "( startswith(Id,'$($M.trimend('*'))') and IsLatestVersion "
                } Else {
                    $Q = $Q + "startswith(Id,'$($M.trimend('*'))')"
                }

            } Else {
                
                If ( $LatestVersion ) {
                    $Q = $Q + "( Id eq '$M' and IsLatestVersion"
                } Else {
                    $Q = $Q + "Id eq '$M'"
                }
            }

            $i++
        }

    }
    
    End {
        If ( $LatestVersion ) {
            $Q = $Q + ')'
        }
        $fQ = $bQ + $Q
        $Uri = "https://www.powershellgallery.com/api/v2/Search()?$fQ"
        Invoke-RestMethod -Method GET -Uri $Uri | Select-Object -ExpandProperty properties

    }
}