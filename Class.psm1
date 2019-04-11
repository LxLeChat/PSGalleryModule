Class GalleryInfo {
    $Title
    $Id
    $Version
    $VersionDownloadCount
    $ModuleDownloadCount
    $NormalizedVersion
    $Authors
    $Copyright
    $Created
    $Dependecies
    $Description
    $GalleryDetailsUrl
    $FileList

    GalleryInfo ($Input) {
        $this.Title = $input.Title.'#Text'
        $this.Id = $input.Properties.id
        $this.Version = $input.Properties.Version
        $this.VersionDownloadCount = $input.Properties.VersionDownloadCount.'#Text'
        $this.ModuleDownloadCount = $input.Properties.DownloadCount.'#Text'
        $this.Authors = $input.Properties.Authors
        $this.Copyright = $input.Properties.Copyright
        $this.Created = get-date $input.properties.Created.'#Text'
        $this.Description = $input.properties.Description
        $this.GalleryDetailsUrl = $input.properties.GalleryDetailsUrl
        $this.FileList = $input.properties.FileList.Split('|')
    }
}