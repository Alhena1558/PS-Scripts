# Function to get system uptime
function Get-SystemUptime {
    $uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $currentTime = Get-Date
    $uptimeDuration = $currentTime - $uptime
    Write-Output "System Uptime: $uptimeDuration"
}

# Run the function
Get-SystemUptime
