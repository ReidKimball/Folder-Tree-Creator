$root = "C:\Users\Reid\Documents"
$outputFile = "C:\Users\Reid\Documents\Programming\PowerShell Scripts\Folder_Tree_Creator\Outputs\Folder_Tree_Documents.txt"

function Get-FolderCount($path) {
    (Get-ChildItem -Path $path -Directory -Recurse -ErrorAction SilentlyContinue).Count
}

function Get-FolderTree($path, $prefix = "", $progress) {
    $items = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue
    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLast = ($i -eq $items.Count - 1)
        $line = if ($isLast) {"$prefix└── $($item.Name)"} else {"$prefix├── $($item.Name)"}
        $line | Out-File -FilePath $outputFile -Append
        
        $progress.Value++
        $percentComplete = [math]::Round(($progress.Value / $progress.Maximum) * 100, 2)
        Write-Progress -Activity "Generating folder tree" -Status "$percentComplete% Complete" -PercentComplete $percentComplete
        
        $newPrefix = if ($isLast) {"$prefix    "} else {"$prefix│   "}
        Get-FolderTree $item.FullName $newPrefix $progress
    }
}

Write-Host "Estimating total folder count..."
$totalFolders = Get-FolderCount $root
$estimatedTime = [TimeSpan]::FromSeconds($totalFolders * 0.1)  # Assuming 0.1 seconds per folder
Write-Host "Estimated time: $($estimatedTime.ToString('hh\:mm\:ss'))"

Write-Host "Starting folder tree generation..."
"C:\Users\Reid\Documents" | Out-File -FilePath $outputFile

$progress = @{
    Value = 0
    Maximum = $totalFolders
}

Get-FolderTree $root "" $progress

Write-Progress -Activity "Generating folder tree" -Completed
Write-Host "Process complete. Output saved to $outputFile"