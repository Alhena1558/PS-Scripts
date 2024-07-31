# TelnetScript.ps1 - README

## Overview
The `TelnetScript.ps1` script is a PowerShell script designed to facilitate running Telnet commands. It initiates a Telnet session to a specified hostname and port, allowing the user to interact with the remote server through a PowerShell interface.

## Features
- Prompts the user for a hostname/IP address and port number.
- Initiates a Telnet session using the specified parameters.
- Provides an interactive interface to send commands to the Telnet session.
- Allows the user to type `exit` to end the Telnet session.

## Requirements
- Windows PowerShell
- Telnet client installed on the system (`telnet.exe`)

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `TelnetScript.ps1`.
2. **Ensure Telnet is Installed**: Make sure the Telnet client is installed on your system. You can install it via Windows Features if it's not already available.
3. **Run the Script**: Open PowerShell and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\TelnetScript.ps1
   ```

4. **Provide Hostname and Port**: When prompted, enter the hostname/IP address and port number for the Telnet session.
5. **Interact with the Telnet Session**: Type your Telnet commands as prompted. Type `exit` to end the session.

## Script Explanation
The script consists of a function `Start-TelnetSession` which performs the following steps:

1. **Function Parameters**: Defines the parameters for the function, including the hostname and port.
   ```powershell
   function Start-TelnetSession {
       param (
           [string]$hostname,
           [int]$port
       )
   ```

2. **Start Telnet Process**: Uses `Start-Process` to initiate a Telnet session to the specified hostname and port.
   ```powershell
   $telnetProcess = Start-Process -FilePath "telnet.exe" -ArgumentList "$hostname $port" -NoNewWindow -PassThru
   ```

3. **Check Telnet Process**: Verifies if the Telnet process started successfully.
   ```powershell
   if ($telnetProcess.HasExited) {
       Write-Host "Failed to start Telnet session."
       return
   }
   ```

4. **Interactive Telnet Loop**: Provides an interactive loop for the user to send commands to the Telnet session. The loop continues until the user types `exit`.
   ```powershell
   while ($true) {
       $input = Read-Host -Prompt "Telnet>"

       if ($input -eq "exit") {
           break
       }

       $telnetProcess.StandardInput.WriteLine($input)
   }
   ```

5. **End Telnet Session**: Ends the Telnet session and terminates the Telnet process.
   ```powershell
   $telnetProcess.Kill()
   Write-Host "Telnet session ended."
   ```

6. **Prompt for Hostname and Port**: Prompts the user to enter the hostname/IP address and port number.
   ```powershell
   $hostname = Read-Host -Prompt "Enter hostname/IP address"
   $port = Read-Host -Prompt "Enter port number"
   ```

7. **Start Telnet Session**: Calls the `Start-TelnetSession` function with the provided hostname and port.
   ```powershell
   Start-TelnetSession -hostname $hostname -port $port
   ```

## Notes
- Ensure the Telnet client (`telnet.exe`) is installed and available in your system's PATH.
- Running the script without Telnet installed will result in an error.
- The script provides a basic interactive interface and may require adjustments for more complex Telnet interactions.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
