# TraceRoute.ps1 - README

## Overview
The `TraceRoute.ps1` script is a PowerShell script designed to perform a traceroute to a specified hostname or IP address using the `tracert` command. This script helps diagnose the path and transit delays of packets across an IP network.

## Features
- Prompts the user for a hostname or IP address.
- Performs a traceroute to the specified target.
- Displays the traceroute output in the PowerShell console.

## Requirements
- Windows PowerShell
- Network connectivity to the target hostname or IP address
- `tracert` command available (included with Windows)

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `TraceRoute.ps1`.
2. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\TraceRoute.ps1
   ```

3. **Provide Target**: When prompted, enter the hostname or IP address for which you want to perform the traceroute.

## Script Explanation
The script consists of a function `Trace-Route` which performs the following steps:

1. **Function Parameters**: Defines the parameter for the function, including the target hostname or IP address.
   ```powershell
   function Trace-Route {
       param (
           [string]$target
       )
   ```

2. **Perform Traceroute**: Uses the `tracert` command to perform a traceroute to the specified target and captures the output.
   ```powershell
   try {
       Write-Output "Traceroute to ${target}:"
       $tracertOutput = tracert $target
       $tracertOutput | ForEach-Object { Write-Output $_ }
   }
   catch {
       Write-Output "Traceroute to ${target} failed."
   }
   ```

3. **Prompt for Target**: Prompts the user to enter the hostname or IP address for the traceroute.
   ```powershell
   $target = Read-Host "Enter the hostname or IP address for traceroute"
   ```

4. **Run the Function**: Calls the `Trace-Route` function with the provided target.
   ```powershell
   Trace-Route -target $target
   ```

## Notes
- Ensure you have network connectivity to the target hostname or IP address.
- The `tracert` command is included with Windows and does not require additional installation.
- The script outputs the traceroute result in the console, showing each hop along the route to the target.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
