# OpenPorts.ps1 - README

## Overview
The `OpenPorts.ps1` script is a PowerShell script designed to check and display the open ports on your system. It uses the `netstat` command to retrieve information about ports that are currently in the "LISTENING" state.

## Features
- Retrieves information about open ports on the system.
- Displays a list of ports that are in the "LISTENING" state.

## Requirements
- Windows PowerShell
- Administrator privileges (recommended for accurate results)
- `netstat` command available (included with Windows)

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `OpenPorts.ps1`.
2. **Run the Script**: Open PowerShell with administrator privileges and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\OpenPorts.ps1
   ```

## Script Explanation
The script consists of a function `Get-OpenPorts` which performs the following steps:

1. **Execute netstat Command**: Uses the `netstat -an` command to retrieve network statistics, including open ports.
   ```powershell
   $netstatOutput = netstat -an | Select-String "LISTENING"
   ```

2. **Output Open Ports**: Filters the `netstat` output to display only the lines containing "LISTENING" and writes the results to the console.
   ```powershell
   Write-Output "Open Ports:"
   $netstatOutput | ForEach-Object { Write-Output $_ }
   ```

3. **Run the Function**: Executes the `Get-OpenPorts` function to display the list of open ports.
   ```powershell
   Get-OpenPorts
   ```

## Notes
- The script uses the `netstat` command, which is included with Windows and does not require any additional installation.
- Running the script with administrator privileges is recommended for accurate and complete results.
- The script outputs the open ports in the console, which includes the protocol, local address, foreign address, and state.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
