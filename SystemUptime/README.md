# SystemUptime.ps1 - README

## Overview
The `SystemUptime.ps1` script is a PowerShell script designed to display the system uptime. It retrieves the last boot-up time of the system and calculates the duration the system has been running.

## Features
- Retrieves the last boot-up time of the system.
- Calculates the total duration the system has been up and running.
- Displays the system uptime in a human-readable format.

## Requirements
- Windows PowerShell
- Windows Management Instrumentation (WMI) support

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `SystemUptime.ps1`.
2. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\SystemUptime.ps1
   ```

## Script Explanation
The script consists of a function `Get-SystemUptime` which performs the following steps:

1. **Retrieve Last Boot-Up Time**: Uses `Get-CimInstance` to fetch the last boot-up time of the operating system.
   ```powershell
   $uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
   ```

2. **Get Current Time**: Retrieves the current date and time.
   ```powershell
   $currentTime = Get-Date
   ```

3. **Calculate Uptime Duration**: Calculates the duration between the current time and the last boot-up time.
   ```powershell
   $uptimeDuration = $currentTime - $uptime
   ```

4. **Output Uptime**: Displays the system uptime in a human-readable format.
   ```powershell
   Write-Output "System Uptime: $uptimeDuration"
   ```

5. **Run the Function**: Executes the `Get-SystemUptime` function to display the system uptime.
   ```powershell
   Get-SystemUptime
   ```

## Notes
- The script uses the `Get-CimInstance` cmdlet to retrieve system information, which is available in Windows PowerShell.
- The uptime is displayed in a format that includes days, hours, minutes, and seconds.
- Ensure you have the necessary permissions to run PowerShell scripts and access system information.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
