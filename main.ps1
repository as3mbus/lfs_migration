#!/usr/bin/powershell -Command

$file = Get-Content -Path "$($PWD.Path)\.gitattributes"
$pattern = "^[^#[][^ ]\w+"  # Regular expression pattern to match the first word

$include_lfs = ""

foreach ($line in $file) {
    # Write-Output $line
    if ($line -match $pattern) {
        # Write-Output $line
        $match = $matches[0]  # Extract the matched string
        # Write-Output $match
        $include_lfs += "$match "
    }
}

$final = $include_lfs -replace " ", ","

# Write-Output $include_lfs

$final = $include_lfs -replace " ", ","

Write-Output $final


git lfs migrate import --include="$final" --everything