$root = "C:\DOOM"
$outputFile = "C:\Users\Reid\Documents\Programming\PowerShell Scripts\Outputs\dir_tree_c2.txt"

function Get-FolderTree($path, $prefix = "") {
    $items = Get-ChildItem -Path $path -Directory -ErrorAction SilentlyContinue
    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLast = ($i -eq $items.Count - 1)
        $line = if ($isLast) {"$prefix└── $($item.Name)"} else {"$prefix├── $($item.Name)"}
        $line | Out-File -FilePath $outputFile -Append
        Write-Host "Writing: $($item.FullName)"
        
        $newPrefix = if ($isLast) {"$prefix    "} else {"$prefix│   "}
        Get-FolderTree $item.FullName $newPrefix
    }
}

Write-Host "Starting folder tree generation..."
"C:\DOOM" | Out-File -FilePath $outputFile
Get-FolderTree $root

Write-Host "Process complete. Output saved to $outputFile"
