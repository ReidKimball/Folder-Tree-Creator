$root = "C:\"
$outputFile = "C:\Users\Reid\Documents\Programming\PowerShell Scripts\Outputs\mkdir_tree_c.txt"

function Get-FolderTree($path) {
    $folders = Get-ChildItem -Path $path -Directory | ForEach-Object {
        $folder = [PSCustomObject]@{
            Name = $_.Name
            Path = $_.FullName
            Depth = $_.FullName.Split("\").Count
        }
        $folder
        Get-FolderTree $_.FullName
    }
    $folders
}

$folderTree = Get-FolderTree $root
$folderTree | ForEach-Object {
    $line = "`t" * ($_.Depth - $root.Split("\").Count) + $_.Name
    $line | Out-File -FilePath $outputFile -Append
}
