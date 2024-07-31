# NetworkConfiguration.ps1 - README

## Overview
The `NetworkConfiguration.ps1` script is a PowerShell script designed to display the network configuration details of your system. It retrieves and formats network interface information, such as IP addresses, subnet masks, and default gateways.

## Features
- Retrieves detailed network configuration information.
- Displays the network configuration in a formatted table for easy readability.

## Requirements
- Windows PowerShell
- Windows operating system with network interfaces configured

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `NetworkConfiguration.ps1`.
2. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\NetworkConfiguration.ps1
   ```

## Script Explanation
The script consists of a function `Get-NetworkConfiguration` which performs the following steps:

1. **Retrieve Network Configuration**: Uses `Get-NetIPConfiguration` to fetch network configuration details for all network interfaces.
   ```powershell
   function Get-NetworkConfiguration {
       Get-NetIPConfiguration | Format-Table -AutoSize
   }
   ```

2. **Display Configuration**: Formats and displays the network configuration in a table for easy readability.
   ```powershell
   Get-NetIPConfiguration | Format-Table -AutoSize
   ```

3. **Run the Function**: Executes the `Get-NetworkConfiguration` function to display the network configuration.
   ```powershell
   Get-NetworkConfiguration
   ```

## Notes
- The script uses the `Get-NetIPConfiguration` cmdlet, which is available in Windows PowerShell.
- Ensure that you have the necessary permissions to run PowerShell scripts and access network configuration details on your system.
- The script outputs the network configuration details in a table format, which includes information such as IP addresses, subnet masks, and default gateways.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
