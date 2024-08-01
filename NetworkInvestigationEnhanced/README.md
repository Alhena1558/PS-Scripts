### README.md for GitHub

```markdown
# Network Investigation Script

## Overview

The `NetworkInvestigationEnhanced.ps1` script is a comprehensive tool designed to perform detailed network investigations. This PowerShell script provides a report that includes IP resolution, ping tests, traceroute, port tests, geolocation, and SSL certificate details. It is ideal for network administrators and IT professionals who need to gather detailed information about network components.

## Features

- **IP Address and Hostname Resolution**: Resolves the IP address and hostname for a given input.
- **Ping Test**: Tests connectivity to the IP address, including detailed response times.
- **Traceroute**: Provides a detailed traceroute to the IP address.
- **Port Test**: Tests the specified port on the IP address and indicates whether the port is open or closed.
- **Geolocation**: Provides geolocation information for the IP address.
- **SSL Certificate Details**: Retrieves and displays SSL certificate details for the hostname.

## Requirements

- PowerShell 5.1 or later
- Internet connection (for geolocation and SSL lookups)

## Usage

### Running the Script

1. **Download the Script**: Save the `NetworkInvestigationEnhanced.ps1` file to your local machine.

2. **Open PowerShell**: Open a PowerShell prompt with administrative privileges.

3. **Navigate to the Script Directory**: Use the `cd` command to navigate to the directory where the script is saved.

4. **Run the Script**: Execute the script with the required `-Address` parameter.

   ```powershell
   ./NetworkInvestigationEnhanced.ps1 -Address "example.com"
   ```

5. **Enter the Port Number**: When prompted, enter the port number you want to test.

### Viewing the Report

After the script completes, it generates an HTML file named `NetworkInvestigationReport.html` in the same directory. The report will automatically open in Google Chrome.

## Example

```powershell
./NetworkInvestigationEnhanced.ps1 -Address "example.com"
```

This command generates a report for the address `example.com`.

## Script Details

### Functions

1. **Resolve-Address**: Resolves the IP address and hostname.
2. **Get-HostnameWithNslookup**: Retrieves the hostname using `nslookup`.
3. **Test-ConnectionPingWithAddress**: Performs a ping test and captures source, destination, and response times.
4. **Get-Traceroute**: Executes a traceroute to the IP address.
5. **Test-Port**: Checks if a specified port is open on the IP address.
6. **Get-Geolocation**: Retrieves geolocation information for the IP address.
7. **Get-SSLCertificate**: Retrieves SSL certificate details for the hostname.

### Error Handling

The script includes error handling for network operations to ensure robust execution and meaningful error messages.


This README provides a comprehensive overview of the script, including its features, requirements, usage instructions, and details about the functions and error handling within the script.
