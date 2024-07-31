# MonitorCPU.ps1 - README

## Overview
The `MonitorCPU.ps1` script is a PowerShell script designed to continuously monitor and display the CPU and memory usage on a Windows system. It provides real-time updates of the system's performance metrics, refreshing every five seconds.

## Features
- Monitors CPU load percentage.
- Monitors total and used memory.
- Provides real-time updates with a five-second refresh interval.
- Clears the console for each update to maintain a clean display.

## Requirements
- Windows PowerShell
- Windows Management Instrumentation (WMI) support

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `MonitorCPU.ps1`.
2. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\MonitorCPU.ps1
   ```

## Script Explanation
The script consists of a function `Monitor-CPUAndMemoryUsage` which performs the following steps:

1. **Continuous Monitoring Loop**: Runs an infinite loop to continuously monitor CPU and memory usage.
   ```powershell
   while ($true) {
   ```

2. **Get CPU Load**: Uses `Get-WmiObject` to retrieve the CPU load percentage.
   ```powershell
   $cpu = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
   ```

3. **Get Memory Usage**: Uses `Get-WmiObject` to retrieve memory usage information, including total and free memory.
   ```powershell
   $memory = Get-WmiObject Win32_OperatingSystem
   $totalMemory = [math]::round($memory.TotalVisibleMemorySize / 1MB, 2)
   $freeMemory = [math]::round($memory.FreePhysicalMemory / 1MB, 2)
   $usedMemory = $totalMemory - $freeMemory
   ```

4. **Clear Console**: Clears the console for a clean display of the current metrics.
   ```powershell
   Clear-Host
   ```

5. **Display Metrics**: Outputs the current CPU load and memory usage.
   ```powershell
   Write-Output "CPU Load: $cpu%"
   Write-Output "Memory Usage: $usedMemory MB / $totalMemory MB"
   ```

6. **Sleep Interval**: Pauses for five seconds before the next update.
   ```powershell
   Start-Sleep -Seconds 5
   ```

7. **Run the Function**: Executes the `Monitor-CPUAndMemoryUsage` function to start monitoring.
   ```powershell
   Monitor-CPUAndMemoryUsage
   ```

## Notes
- The script runs in an infinite loop, providing continuous monitoring until manually stopped.
- To stop the script, use `Ctrl + C` in the PowerShell console.
- The script clears the console for each update, which may not retain previous data. If you prefer to keep a log, consider modifying the script to append output to a file.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
