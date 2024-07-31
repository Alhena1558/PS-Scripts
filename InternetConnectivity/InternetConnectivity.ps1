# Function to test internet connectivity
function Test-InternetConnectivity {
    $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 4
    if ($pingResult.StatusCode -eq 0) {
        Write-Output "Internet connectivity is working."
    } else {
        Write-Output "Internet connectivity is not working."
    }
}

# Run the function
Test-InternetConnectivity
