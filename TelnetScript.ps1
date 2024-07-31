# PowerShell script to run Telnet commands

# Function to start Telnet session
function Start-TelnetSession {
    param (
        [string]$hostname,
        [int]$port
    )

    # Start Telnet process
    $telnetProcess = Start-Process -FilePath "telnet.exe" -ArgumentList "$hostname $port" -NoNewWindow -PassThru

    # Check if Telnet process started successfully
    if ($telnetProcess.HasExited) {
        Write-Host "Failed to start Telnet session."
        return
    }

    Write-Host "Telnet session started. Type 'exit' to end the session."

    # Enter Telnet loop
    while ($true) {
        $input = Read-Host -Prompt "Telnet>"

        if ($input -eq "exit") {
            break
        }

        # Send input to Telnet process
        $telnetProcess.StandardInput.WriteLine($input)
    }

    # End Telnet session
    $telnetProcess.Kill()
    Write-Host "Telnet session ended."
}

# Prompt for hostname and port
$hostname = Read-Host -Prompt "Enter hostname/IP address"
$port = Read-Host -Prompt "Enter port number"

# Start Telnet session
Start-TelnetSession -hostname $hostname -port $port
