# ManageServices.ps1 - README

## Overview
The `ManageServices.ps1` script is a PowerShell script designed to manage Windows services. It provides functionalities to list running and stopped services, select specific services to stop, and optionally restart them. The script ensures it runs with elevated permissions to perform these actions effectively.

## Features
- Checks if the script is running with elevated permissions.
- Restarts the script with elevated permissions if not already elevated.
- Lists all running and stopped services.
- Allows the user to select specific services to stop.
- Optionally restarts stopped services.

## Requirements
- Windows PowerShell
- Administrator privileges

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `ManageServices.ps1`.
2. **Run the Script**: Open PowerShell with administrator privileges and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\ManageServices.ps1
   ```

## Script Explanation
The script consists of several functions that work together to manage services:

1. **Test-IsAdmin**: Checks if the script is running with elevated permissions.
   ```powershell
   function Test-IsAdmin {
       $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
       return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
   }
   ```

2. **Start-Elevated**: Restarts the script with elevated permissions if not already elevated.
   ```powershell
   function Start-Elevated {
       if (-not (Test-IsAdmin)) {
           $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
           $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($myInvocation.MyCommand.Path)`""
           $newProcess.Verb = "runas"
           [System.Diagnostics.Process]::Start($newProcess) | Out-Null
           exit
       }
   }
   ```

3. **List-Services**: Lists running and stopped services.
   ```powershell
   function List-Services {
       $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }
       $stoppedServices = Get-Service | Where-Object { $_.Status -eq 'Stopped' }

       Write-Output "`nRunning Services:"
       $runningServices | Select-Object DisplayName, Name, Status | Format-Table -AutoSize

       Write-Output "`nStopped Services:"
       $stoppedServices | Select-Object DisplayName, Name, Status | Format-Table -AutoSize
   }
   ```

4. **Select-Services**: Prompts the user to select services by name.
   ```powershell
   function Select-Services {
       $serviceNames = Read-Host "Enter the names of the services to stop (comma-separated)"
       $selectedNames = $serviceNames -split ',' | ForEach-Object { $_.Trim() }
       $selectedServices = Get-Service | Where-Object { $selectedNames -contains $_.Name }
       return $selectedServices
   }
   ```

5. **Stop-SelectedServices**: Stops selected services.
   ```powershell
   function Stop-SelectedServices {
       param (
           [array]$services
       )

       $stoppedServices = @()

       foreach ($service in $services) {
           if ($service.Status -eq 'Running') {
               try {
                   Stop-Service -Name $service.Name -Force -ErrorAction Stop
                   Start-Sleep -Seconds 3
                   $service.Refresh()
                   if ($service.Status -eq 'Stopped') {
                       Write-Output "Stopped service: $($service.Name)"
                       $stoppedServices += $service
                   } else {
                       Write-Output "Failed to stop service: $($service.Name) - Service is still running."
                   }
               } catch {
                   Write-Output "Failed to stop service: $($service.Name)"
                   Write-Output "Error: $($_.Exception.Message)"
               }
           }
       }

       if ($stoppedServices.Count -gt 0) {
           Write-Output "`nThe following services have been stopped:"
           $stoppedServices | Select-Object DisplayName, Name | Format-Table -AutoSize
       } else {
           Write-Output "`nNo services were stopped."
       }

       return $stoppedServices
   }
   ```

6. **Restart-SelectedServices**: Restarts selected services.
   ```powershell
   function Restart-SelectedServices {
       param (
           [array]$services
       )

       foreach ($service in $services) {
           $response = Read-Host "Do you want to restart the service $($service.Name)? (Y/N)"
           if ($response -eq 'Y' -or $response -eq 'y') {
               try {
                   Start-Service -Name $service.Name -ErrorAction Stop
                   Start-Sleep -Seconds 3
                   $service.Refresh()
                   if ($service.Status -eq 'Running') {
                       Write-Output "Started service: $($service.Name)"
                       $serviceAfterStart = Get-Service -Name $service.Name
                       $startTime = (Get-Date) - $serviceAfterStart.StartTime
                       Write-Output "Service $($service.Name) has been running for: $startTime"
                   } else {
                       Write-Output "Failed to start service: $($service.Name) - Service did not start."
                   }
               } catch {
                   Write-Output "Failed to start service: $($service.Name)"
                   Write-Output "Error: $($_.Exception.Message)"
               }
           } else {
               Write-Output "Skipped restarting service: $($service.Name)"
           }
       }
   }
   ```

7. **Main Script Execution**: Ensures elevated permissions, lists services, selects and stops services, and optionally restarts them.
   ```powershell
   Start-Elevated

   List-Services

   $selectedServices = Select-Services
   $stoppedServices = Stop-SelectedServices -services $selectedServices

   if ($stoppedServices.Count -gt 0) {
       Restart-SelectedServices -services $stoppedServices
   }
   ```

## Notes
- The script must be run with elevated permissions to manage services effectively.
- It provides a user-friendly interface to select and manage services.
- Ensure you have appropriate permissions and understand the implications of stopping and restarting services on your system.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
