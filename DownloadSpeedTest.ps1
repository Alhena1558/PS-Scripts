# Function to test download speed
function Test-DownloadSpeed {
    $url = "http://speedtest.tele2.net/1MB.zip" # A URL to a test file
    $filePath = "$env:TEMP\1MB.zip"
    
    $startTime = Get-Date
    Invoke-WebRequest -Uri $url -OutFile $filePath
    $endTime = Get-Date

    $duration = $endTime - $startTime
    $fileSizeMB = 1 # The size of the file in MB

    $speedMbps = ($fileSizeMB * 8) / $duration.TotalSeconds
    Write-Output "Download speed: $([math]::round($speedMbps, 2)) Mbps"
}

# Run the function
Test-DownloadSpeed
