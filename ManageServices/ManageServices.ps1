# Function to check if the script is running with elevated permissions
function Test-IsAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to restart the script with elevated permissions if not already elevated
function Start-Elevated {
    if (-not (Test-IsAdmin)) {
        $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
        $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($myInvocation.MyCommand.Path)`""
        $newProcess.Verb = "runas"
        [System.Diagnostics.Process]::Start($newProcess) | Out-Null
        exit
    }
}

# Function to list running and stopped services
function List-Services {
    $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }
    $stoppedServices = Get-Service | Where-Object { $_.Status -eq 'Stopped' }

    Write-Output "`nRunning Services:"
    $runningServices | Select-Object DisplayName, Name, Status | Format-Table -AutoSize

    Write-Output "`nStopped Services:"
    $stoppedServices | Select-Object DisplayName, Name, Status | Format-Table -AutoSize
}

# Function to prompt user to select services by name
function Select-Services {
    $serviceNames = Read-Host "Enter the names of the services to stop (comma-separated)"
    $selectedNames = $serviceNames -split ',' | ForEach-Object { $_.Trim() }
    $selectedServices = Get-Service | Where-Object { $selectedNames -contains $_.Name }
    return $selectedServices
}

# Function to stop selected services
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

# Function to restart selected services
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

# Main script
Start-Elevated

List-Services

$selectedServices = Select-Services
$stoppedServices = Stop-SelectedServices -services $selectedServices

if ($stoppedServices.Count -gt 0) {
    Restart-SelectedServices -services $stoppedServices
}
