# StopRestartServices.ps1 - README

## Overview
The `StopRestartServices.ps1` script is a PowerShell script designed to stop and optionally restart selected services on a Windows system. The script ensures it runs with elevated permissions, lists currently running services, and allows the user to select services to stop and restart.

## Features
- Checks and ensures the script is running with elevated permissions.
- Lists currently running services with their display and internal names.
- Stops selected services based on user input.
- Optionally restarts the stopped services based on user confirmation.

## Requirements
- Windows PowerShell
- Administrator privileges (required for stopping and restarting services)

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `StopRestartServices.ps1`.
2. **Run the Script**: Open PowerShell with administrator privileges and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\StopRestartServices.ps1
   ```

3. **Follow the Prompts**:
   - The script will list currently running services.
   - Enter the internal names of the services you want to stop (comma-separated) when prompted.
   - Confirm if you want to restart each stopped service when prompted.

## Script Explanation
The script consists of several functions and a main execution block that performs the following steps:

### Functions

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
           Write-Output "Script is not running as an administrator. Restarting with elevated privileges..."
           $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
           $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($myInvocation.MyCommand.Path)`""
           $newProcess.Verb = "runas"
           [System.Diagnostics.Process]::Start($newProcess) | Out-Null
           exit
       } else {
           Write-Output "Script is running with elevated privileges."
       }
   }
   ```

3. **List-RunningServices**: Lists running services with their display and internal names.
   ```powershell
   function List-RunningServices {
       $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }

       Write-Output "`nRunning Services:"
       $runningServices | Select-Object DisplayName, Name | Format-Table -AutoSize
   }
   ```

4. **Stop-SelectedServices**: Stops selected services based on user input.
   ```powershell
   function Stop-SelectedServices {
       param (
           [array]$serviceNames
       )

       $stoppedServices = @()

       foreach ($serviceName in $serviceNames) {
           try {
               Stop-Service -Name $serviceName -Force -ErrorAction Stop
               Write-Output "Stopped service: $serviceName"
               $stoppedServices += $serviceName
           } catch {
               Write-Output "Failed to stop service: $serviceName"
               Write-Output "Error: $($_.Exception.Message)"
           }
       }

       return $stoppedServices
   }
   ```

5. **Restart-SelectedServices**: Restarts selected services based on user confirmation.
   ```powershell
   function Restart-SelectedServices {
       param (
           [array]$serviceNames
       )

       foreach ($serviceName in $serviceNames) {
           $response = Read-Host "Do you want to restart the service $serviceName? (Y/N)"
           if ($response -eq 'Y' -or $response -eq 'y') {
               try {
                   Start-Service -Name $serviceName -ErrorAction Stop
                   Write-Output "Started service: $serviceName"
               } catch {
                   Write-Output "Failed to start service: $serviceName"
                   Write-Output "Error: $($_.Exception.Message)"
               }
           } else {
               Write-Output "Skipped restarting service: $serviceName"
           }
       }
   }
   ```

### Main Script Execution
- Checks for elevated permissions and restarts the script if necessary.
- Lists currently running services.
- Prompts the user to enter the internal names of the services to stop.
- Stops the selected services.
- Prompts the user to confirm if they want to restart the stopped services.
- Restarts the confirmed services.

   ```powershell
   Write-Output "Starting script..."

   Start-Elevated

   Write-Output "Listing running services..."
   List-RunningServices

   $serviceNames = Read-Host "Enter the internal names of the services to stop (comma-separated)"
   $selectedServices = $serviceNames -split ',' | ForEach-Object { $_.Trim() }

   if ($selectedServices.Count -eq 0) {
       Write-Output "No service names entered. Exiting."
       exit
   }

   Write-Output "Stopping selected services..."
   $stoppedServices = Stop-SelectedServices -serviceNames $selectedServices

   if ($stoppedServices.Count -gt 0) {
       Write-Output "Restarting stopped services..."
       Restart-SelectedServices -serviceNames $stoppedServices
   }

   Write-Output "Script completed."
   ```

## Notes
- The script must be run with elevated permissions to stop and restart services.
- Enter the internal names of the services correctly to avoid errors.
- The script provides user-friendly prompts and outputs for each step.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
