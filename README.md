# InternetConnectivity.ps1 - README

## Overview
The `InternetConnectivity.ps1` script is a straightforward PowerShell script designed to test the internet connectivity of your system by pinging a well-known DNS server (8.8.8.8). This script helps determine whether your internet connection is functioning correctly.

## Features
- Pings Google's public DNS server (8.8.8.8).
- Checks the status of the internet connection.
- Outputs the result of the connectivity test to the console.

## Requirements
- Windows PowerShell
- Internet connection

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `InternetConnectivity.ps1`.
2. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\InternetConnectivity.ps1
   ```

## Script Explanation
The script consists of a function `Test-InternetConnectivity` which performs the following steps:

1. **Ping Google's DNS Server**: Uses `Test-Connection` to send four ICMP echo requests (pings) to 8.8.8.8.
   ```powershell
   $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 4
   ```

2. **Check Ping Result**: Evaluates the status of the ping results to determine internet connectivity.
   ```powershell
   if ($pingResult.StatusCode -eq 0) {
       Write-Output "Internet connectivity is working."
   } else {
       Write-Output "Internet connectivity is not working."
   }
   ```

3. **Run the Function**: Executes the `Test-InternetConnectivity` function to perform the internet connectivity test.
   ```powershell
   Test-InternetConnectivity
   ```

## Notes
- The script pings Google's public DNS server (8.8.8.8). You can change the target server by modifying the `-ComputerName` parameter.
- The script sends four pings by default. You can adjust the number of pings by changing the `-Count` parameter.
- The result of the connectivity test is an approximation and may vary based on network conditions and other factors.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
