#!/usr/bin/powershell -Command

git lfs fetch --all

$file_path = "$($PWD.Path)\.gitattributes"
$file = Get-Content -Path $file_path
$pattern = "^[^#[][^ ]\w+"  # Regular expression pattern to match the first word

$include_lfs = ""

$lfs_count = 0
foreach ($line in $file) {
    # Write-Output $line
    if ($line -match $pattern) {
        # Write-Output $line
        $match = $matches[0]  # Extract the matched string
        # Write-Output $match
        $include_lfs += "$match "
        $lfs_count += 1
    }
}

$final = $include_lfs -replace " ", ","

Write-Output $final.Length
$final = $final.Substring(0, $final.Length-1)
$final = $final -replace " ", ","

Write-Output $final

git lfs migrate import --include="$final" --everything

# Replace "N" with the number of lines to delete from the end of the file
$linesToDelete = $lfs_count

# Read the contents of the file into an array of strings
$content =  Get-Content -Path $file_path

# Delete the specified number of lines from the end of the array
$newContent = $content[0..($content.Length - $linesToDelete - 1)]

Write-Output $linesToDelete
Write-Output $newContent

# Write the modified array back to the file
Set-Content $file_path $newContent

git add $file_path

git commit -m "chores : clear generated git attribute after lfs migration"