# Define the directory path as the current directory
$directory = Get-Location

# Get all files in the directory
$files = Get-ChildItem -Path $directory -File

# Initialize an empty array to store file details
$fileDetails = @()

# Loop through each file and add its details to the array
foreach ($file in $files) {
    $fileDetails += @{
        Name = $file.Name
        FullName = $file.FullName
        Length = $file.Length
        LastWriteTime = $file.LastWriteTime
    }
}

# Convert the array to JSON
$json = $fileDetails | ConvertTo-Json -Depth 10

# Write the JSON to a file
$json | Out-File -FilePath "$directory\file.json"