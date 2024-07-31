# DownloadSpeed.ps1 - README

## Overview
The `DownloadSpeed.ps1` script is a simple PowerShell script designed to test your internet download speed by downloading a small test file and calculating the download speed in Mbps (Megabits per second). This script can be useful for quick checks of your internet connection speed.

## Features
- Downloads a 1MB test file from a specified URL.
- Calculates the download speed in Mbps.
- Outputs the download speed to the console.

## Requirements
- Windows PowerShell
- Internet connection

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `DownloadSpeed.ps1`.
2. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\DownloadSpeed.ps1
   ```

## Script Explanation
The script consists of a function `Test-DownloadSpeed` which performs the following steps:

1. **Define the URL**: Sets the URL of the test file to be downloaded.
   ```powershell
   $url = "http://speedtest.tele2.net/1MB.zip"
   ```
   
2. **Set the File Path**: Specifies the temporary file path where the test file will be downloaded.
   ```powershell
   $filePath = "$env:TEMP\1MB.zip"
   ```

3. **Record Start Time**: Captures the start time before beginning the download.
   ```powershell
   $startTime = Get-Date
   ```

4. **Download the File**: Uses `Invoke-WebRequest` to download the test file to the specified file path.
   ```powershell
   Invoke-WebRequest -Uri $url -OutFile $filePath
   ```

5. **Record End Time**: Captures the end time after the download completes.
   ```powershell
   $endTime = Get-Date
   ```

6. **Calculate Duration**: Computes the duration of the download.
   ```powershell
   $duration = $endTime - $startTime
   ```

7. **Calculate Speed**: Calculates the download speed in Mbps.
   ```powershell
   $fileSizeMB = 1
   $speedMbps = ($fileSizeMB * 8) / $duration.TotalSeconds
   ```

8. **Output Speed**: Outputs the calculated download speed to the console.
   ```powershell
   Write-Output "Download speed: $([math]::round($speedMbps, 2)) Mbps"
   ```

9. **Run the Function**: Executes the `Test-DownloadSpeed` function to perform the download speed test.
   ```powershell
   Test-DownloadSpeed
   ```

## Notes
- The script uses a 1MB file for testing. You can change the URL to a different file if needed.
- The calculated download speed is an approximation and may vary based on network conditions and other factors.
- Ensure you have write access to the specified temporary file path.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
