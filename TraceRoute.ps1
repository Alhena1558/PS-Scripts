# Function to perform a traceroute using tracert
function Trace-Route {
    param (
        [string]$target
    )
    try {
        Write-Output "Traceroute to ${target}:"
        $tracertOutput = tracert $target
        $tracertOutput | ForEach-Object { Write-Output $_ }
    }
    catch {
        Write-Output "Traceroute to ${target} failed."
    }
}

# Prompt user for hostname or IP address
$target = Read-Host "Enter the hostname or IP address for traceroute"

# Run the function
Trace-Route -target $target

