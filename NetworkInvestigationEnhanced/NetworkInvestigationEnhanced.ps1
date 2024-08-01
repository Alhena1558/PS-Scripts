<#
.SYNOPSIS
    Performs a comprehensive network investigation, including IP resolution, ping test, traceroute, port test, geolocation, and SSL certificate details.

.DESCRIPTION
    This script provides a detailed network investigation report for a given IP address or hostname. It performs multiple tests and generates an HTML report with the results.

.PARAMETER Address
    The IP address or hostname to investigate.

.EXAMPLE
    .\NetworkInvestigationEnhanced.ps1 -Address "151.101.64.81"

.NOTES
    Author: Alhena1558
    Date: 240801
    Version: 1.0
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Address
)

function Resolve-Address {
    param (
        [string]$address
    )
    
    if ($address -match "^\d{1,3}(\.\d{1,3}){3}$") {
        $ipAddress = $address
        $hostname = Get-HostnameWithNslookup -ip $address
    } else {
        $hostname = $address
        try {
            $ipAddress = [System.Net.Dns]::GetHostAddresses($address)[0].IPAddressToString
        } catch {
            $ipAddress = "Failed to resolve IP address for hostname $address"
        }
    }
    
    return @{
        IPAddress = $ipAddress
        Hostname = $hostname
    }
}

function Get-HostnameWithNslookup {
    param (
        [string]$ip
    )
    try {
        $nslookupResult = nslookup $ip
        if ($nslookupResult -match "Name:\s+(?<hostname>\S+)") {
            return $matches['hostname']
        } else {
            return "No hostname found for IP address $ip"
        }
    }
    catch {
        return "Failed to perform nslookup for IP address $ip"
    }
}

function Test-ConnectionPingWithAddress {
    param (
        [string]$ip
    )
    try {
        $pingResults = Test-Connection -ComputerName $ip -Count 4 -ErrorAction Stop
        $sourceIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress }).IPAddress
        $pingData = @()
        foreach ($result in $pingResults) {
            $pingData += [PSCustomObject]@{
                Source = $sourceIP
                Destination = $result.Address
                IPV4Address = $result.Address
                IPV6Address = $null
                Bytes = $result.BufferSize
                Time_ms = $result.ResponseTime
            }
        }
        return $pingData | Format-Table -AutoSize | Out-String
    }
    catch {
        return "Ping test failed for IP address $ip"
    }
}

function Get-Traceroute {
    param (
        [string]$ip
    )
    $tracerouteResult = tracert.exe $ip
    return $tracerouteResult | Out-String
}

function Test-Port {
    param (
        [string]$ip,
        [int]$port
    )
    try {
        $tcpConnection = Test-NetConnection -ComputerName $ip -Port $port
        return $tcpConnection.TcpTestSucceeded
    }
    catch {
        return $false
    }
}

function Get-Geolocation {
    param (
        [string]$ip
    )
    try {
        $geoResult = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip"
        return "Country: $($geoResult.country), Region: $($geoResult.regionName), City: $($geoResult.city)"
    }
    catch {
        return "Geolocation lookup failed for IP address $ip"
    }
}

function Get-SSLCertificate {
    param (
        [string]$hostname,
        [int]$port = 443
    )
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient($hostname, $port)
        $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false, ({$true}))
        $sslStream.AuthenticateAsClient($hostname)
        $cert = $sslStream.RemoteCertificate
        
        if ($cert -ne $null) {
            $certDetails = New-Object PSObject -Property @{
                "Subject" = $cert.Subject
                "Issuer" = $cert.Issuer
                "EffectiveDate" = $cert.GetEffectiveDateString()
                "ExpiryDate" = $cert.GetExpirationDateString()
                "Thumbprint" = $cert.GetCertHashString()
            }
            return $certDetails | Format-List | Out-String
        } else {
            return "No SSL certificate found for $hostname on port $port"
        }
    }
    catch {
        Write-Host "Error retrieving SSL certificate: $_"
        return "Failed to retrieve SSL certificate for $hostname on port $port. Error: $_"
    }
    finally {
        if ($tcpClient -ne $null) {
            $tcpClient.Close()
        }
    }
}

# Prompt user for port number
$portNumber = Read-Host "Enter the port number you want to test"

# Run tests and collect results
$results = @{}

Write-Host "Resolving address: $Address..."
$resolved = Resolve-Address -address $Address
$ipAddress = $resolved["IPAddress"]
$hostname = $resolved["Hostname"]

Write-Host "Resolved IP address: $ipAddress"
Write-Host "Resolved hostname: $hostname"

$results["IP Address"] = $ipAddress
$results["Hostname"] = $hostname

$portTestResult = Test-Port -ip $ipAddress -port $portNumber
$results["Port Test (Port $portNumber)"] = if ($portTestResult) { "Open" } else { "Closed" }

$pingResult = Test-ConnectionPingWithAddress -ip $ipAddress
$results["Ping Test"] = $pingResult

$tracerouteResult = Get-Traceroute -ip $ipAddress
$results["Traceroute"] = $tracerouteResult

$geoResult = Get-Geolocation -ip $ipAddress
$results["Geolocation"] = $geoResult

Write-Host "Retrieving SSL certificate details for $hostname on port $portNumber..."
$sslCertResult = Get-SSLCertificate -hostname $hostname -port $portNumber
Write-Host "SSL certificate details retrieved: $sslCertResult"
$results["SSL Certificate Details"] = $sslCertResult

# Generate HTML report
$htmlReport = @"
<!DOCTYPE html>
<html>
<head>
    <title>Network Investigation Report</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 15px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        pre {
            white-space: pre-wrap; /* css-3 */
            white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
            white-space: -pre-wrap; /* Opera 4-6 */
            white-space: -o-pre-wrap; /* Opera 7 */
            word-wrap: break-word; /* Internet Explorer 5.5+ */
        }
    </style>
</head>
<body>
    <h2>Network Investigation Report for Address: $Address</h2>
    <table>
        <tr>
            <th>Test</th>
            <th>Result</th>
        </tr>
        <tr>
            <td>Port Test (Port $portNumber)</td>
            <td><pre>$($results['Port Test (Port $portNumber)'])</pre></td>
        </tr>
        <tr>
            <td>IP Address</td>
            <td><pre>$($results['IP Address'])</pre></td>
        </tr>
        <tr>
            <td>Hostname</td>
            <td><pre>$($results['Hostname'])</pre></td>
        </tr>
        <tr>
            <td>Ping Test</td>
            <td><pre>$($results['Ping Test'])</pre></td>
        </tr>
        <tr>
            <td>Traceroute</td>
            <td><pre>$($results['Traceroute'])</pre></td>
        </tr>
        <tr>
            <td>Geolocation</td>
            <td><pre>$($results['Geolocation'])</pre></td>
        </tr>
        <tr>
            <td>SSL Certificate Details</td>
            <td><pre>$($results['SSL Certificate Details'])</pre></td>
        </tr>
    </table>
</body>
</html>
"@

# Save HTML report to a file
$htmlFilePath = "$PSScriptRoot\NetworkInvestigationReport.html"
$htmlReport | Out-File -FilePath $htmlFilePath -Encoding utf8

Write-Host "Network investigation report generated: $htmlFilePath"

# Open the HTML report in Google Chrome
Start-Process "chrome.exe" -ArgumentList $htmlFilePath
