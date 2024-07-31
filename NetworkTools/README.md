# NetworkTools.ps1 - README

## Overview
The `NetworkTools.ps1` script is a PowerShell script designed to provide basic network utility functions. It supports reverse DNS lookup (IP to hostname), forward DNS lookup (hostname to IP), and ping tests. This script is useful for network troubleshooting and verification tasks.

## Features
- **Reverse DNS Lookup**: Converts an IP address to its corresponding hostname.
- **Forward DNS Lookup**: Converts a hostname to its corresponding IP address(es).
- **Ping Test**: Tests the network connectivity to a specified hostname or IP address.

## Requirements
- Windows PowerShell
- Internet or network connection

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `NetworkTools.ps1`.
2. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\NetworkTools.ps1
   ```

3. **Choose an Operation**: When prompted, enter the number corresponding to the desired operation:
   - Enter '1' for reverse lookup (IP to hostname).
   - Enter '2' for forward lookup (hostname to IP).
   - Enter '3' for a ping test.

4. **Provide Input**: Follow the subsequent prompts to enter the required information (IP address, hostname, or target for ping).

## Script Explanation
The script consists of several functions and a main execution block that prompts the user for input and executes the appropriate function based on the user's choice.

### Functions

1. **Reverse-DnsLookup**
   ```powershell
   function Reverse-DnsLookup {
       param (
           [string]$ipAddress
       )
       try {
           $hostEntry = [System.Net.Dns]::GetHostEntry($ipAddress)
           $hostName = $hostEntry.HostName
           Write-Output "IP Address: $ipAddress"
           Write-Output "Hostname: $hostName"
       }
       catch {
           Write-Output "No hostname found for IP address $ipAddress"
       }
   }
   ```
   - Performs a reverse DNS lookup to find the hostname for a given IP address.

2. **Forward-DnsLookup**
   ```powershell
   function Forward-DnsLookup {
       param (
           [string]$hostName
       )
       try {
           $hostEntry = [System.Net.Dns]::GetHostEntry($hostName)
           $ipAddresses = $hostEntry.AddressList | ForEach-Object { $_.IPAddressToString }
           Write-Output "Hostname: $hostName"
           Write-Output "IP Address(es):"
           $ipAddresses | ForEach-Object { Write-Output "  $_" }
       }
       catch {
           Write-Output "No IP address found for hostname $hostName"
       }
   }
   ```
   - Performs a forward DNS lookup to find the IP address(es) for a given hostname.

3. **Ping-Test**
   ```powershell
   function Ping-Test {
       param (
           [string]$target
       )
       try {
           $pingResult = Test-Connection -ComputerName $target -Count 4 -ErrorAction Stop
           Write-Output "Ping results for ${target}:"
           $pingResult | ForEach-Object {
               Write-Output "  Response from $($_.Address): Bytes=$($_.BufferSize) Time=$($_.ResponseTime)ms TTL=$($_.ReplyTimeToLive)"
           }
       }
       catch {
           Write-Output "Ping request to ${target} failed."
       }
   }
   ```
   - Performs a ping test to check the network connectivity to a specified hostname or IP address.

### Main Execution Block
- Prompts the user to select an operation and provides the corresponding input.
   ```powershell
   $operationType = Read-Host "Enter '1' for reverse lookup (IP to hostname), '2' for forward lookup (hostname to IP), or '3' for ping test"
   
   if ($operationType -eq '1') {
       $ipAddress = Read-Host "Enter the IP address"
       Reverse-DnsLookup -ipAddress $ipAddress
   } elseif ($operationType -eq '2') {
       $hostName = Read-Host "Enter the hostname"
       Forward-DnsLookup -hostName $hostName
   } elseif ($operationType -eq '3') {
       $target = Read-Host "Enter the hostname or IP address to ping"
       Ping-Test -target $target
   } else {
       Write-Output "Invalid selection. Please enter '1', '2', or '3'."
   }
   ```

## Notes
- The script provides a user-friendly interface to perform basic network operations.
- Ensure you have appropriate permissions and network access to perform DNS lookups and ping tests.
- The script handles exceptions and provides meaningful output for failed operations.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
