[CmdletBinding()]
PARAM(
    $modulePath=(Split-Path -Path $PSScriptRoot -parent),
    $moduleName='PSGalleryModule')

begin{
    # Find the Manifest file
    $ManifestFile = "$modulePath\$ModuleName.psd1"

    # Unload any module with same name
    Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore

    # Import Module
    $ModuleInformation = Import-Module -Name $ManifestFile -Force -ErrorAction Stop -PassThru
}
end{
    $ModuleInformation | Remove-Module -ErrorAction SilentlyContinue
}
process{
    Describe "$ModuleName Module - Testing Manifest File (.psd1)" {
        Context "Manifest"{
            It "Should contains RootModule"{
                $ModuleInformation.RootModule | Should not BeNullOrEmpty
            }
            It "Should contains Author"{
                $ModuleInformation.Author | Should not BeNullOrEmpty
            }
            It "Should contains Company Name"{
                $ModuleInformation.CompanyName | Should not BeNullOrEmpty
            }
            It "Should contains Description"{
                $ModuleInformation.Description | Should not BeNullOrEmpty
            }
            It "Should contains Copyright"{
                $ModuleInformation.Copyright | Should not BeNullOrEmpty
            }
            It "Should contains License"{
                $ModuleInformation.LicenseURI | Should not BeNullOrEmpty
            }
            It "Should contains a Project Link"{
                $ModuleInformation.ProjectURI | Should not BeNullOrEmpty
            }
            It "Should contains a Tags (For the PSGallery)"{
                $ModuleInformation.Tags.count | Should not BeNullOrEmpty
            }
        }
    }
}