# Define the function to check netstat
function Check-Netstat {
    # Run netstat command and capture the output
    $netstatOutput = netstat -an

    # Display the netstat output
    Write-Output "Netstat Output:"
    Write-Output $netstatOutput

    # Filter and display listening ports
    Write-Output "`nListening Ports:"
    $netstatOutput | Select-String "LISTENING"

    # Filter and display established connections
    Write-Output "`nEstablished Connections:"
    $netstatOutput | Select-String "ESTABLISHED"
}

# Run the function
Check-Netstat
