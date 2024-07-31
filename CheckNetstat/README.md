# CheckNetstat.ps1 README

## Overview

`CheckNetstat.ps1` is a PowerShell script designed to capture and display the output of the `netstat` command. This script provides a comprehensive overview of network statistics, including listening ports and established connections.

## Script Details

The script defines and runs a function called `Check-Netstat` which performs the following actions:
1. Executes the `netstat -an` command and captures its output.
2. Displays the full `netstat` output.
3. Filters and displays only the listening ports.
4. Filters and displays only the established connections.

## Prerequisites

- Windows Operating System
- PowerShell installed

## Usage

### Steps to Run the Script

1. **Open PowerShell as Administrator**
   - It is recommended to run this script with administrative privileges to ensure all network connections can be accurately reported.

2. **Navigate to the Script Directory**
   - Change the directory to where `CheckNetstat.ps1` is located. For example:
     ```powershell
     cd "C:\Path\To\Your\Script"
     ```

3. **Execute the Script**
   - Run the script by typing:
     ```powershell
     .\CheckNetstat.ps1
     ```

### Example Output

The script will display output similar to the following:

```
Netstat Output:
Proto  Local Address          Foreign Address        State
TCP    0.0.0.0:135            0.0.0.0:0              LISTENING
TCP    192.168.1.2:49152      192.168.1.1:80         ESTABLISHED

Listening Ports:
TCP    0.0.0.0:135            0.0.0.0:0              LISTENING

Established Connections:
TCP    192.168.1.2:49152      192.168.1.1:80         ESTABLISHED
```

## Important Notes

- Ensure your execution policy allows the running of scripts. If not, you can set the execution policy to allow script execution by running the following command in PowerShell:
  ```powershell
  Set-ExecutionPolicy RemoteSigned
  ```

- The script can be modified to include additional filters or to output results to a file as needed.

## Troubleshooting

- **Permission Issues**: If you encounter permission issues, make sure to run PowerShell as an administrator.
- **Execution Policy**: If scripts are blocked, verify and set the correct execution policy using:
  ```powershell
  Get-ExecutionPolicy
  Set-ExecutionPolicy RemoteSigned
  ```

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
