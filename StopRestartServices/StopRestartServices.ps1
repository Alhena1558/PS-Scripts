# Function to check if the script is running with elevated permissions
function Test-IsAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to restart the script with elevated permissions if not already elevated
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

# Function to list running services with internal names
function List-RunningServices {
    $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }

    Write-Output "`nRunning Services:"
    $runningServices | Select-Object DisplayName, Name | Format-Table -AutoSize
}

# Function to stop selected services
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

# Function to restart selected services
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

# Main script
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
