# Function to check open ports
function Get-OpenPorts {
    $netstatOutput = netstat -an | Select-String "LISTENING"
    Write-Output "Open Ports:"
    $netstatOutput | ForEach-Object { Write-Output $_ }
}

# Run the function
Get-OpenPorts
