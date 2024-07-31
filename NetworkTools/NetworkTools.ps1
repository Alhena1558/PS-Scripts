# Function to perform reverse DNS lookup
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

# Function to perform forward DNS lookup
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

# Function to perform ping test
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

# Prompt user for type of operation
$operationType = Read-Host "Enter '1' for reverse lookup (IP to hostname), '2' for forward lookup (hostname to IP), or '3' for ping test"

# Execute based on user choice
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
