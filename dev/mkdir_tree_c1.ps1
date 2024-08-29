$root = "C:\DOOM"
$outputFile = "C:\Users\Reid\Documents\Programming\PowerShell Scripts\Outputs\dir_tree_c1.txt"

function Get-FolderTree($path) {
    $folders = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
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

Write-Host "Starting folder tree generation..."
$folderTree = Get-FolderTree $root
Write-Host "Folder tree generated. Writing to file..."

$folderTree | ForEach-Object {
    $line = "`t" * ($_.Depth - $root.Split("\").Count) + $_.Name
    $line | Out-File -FilePath $outputFile -Append
    Write-Host "Writing: $($_.Path)"
}

Write-Host "Process complete. Output saved to $outputFile"