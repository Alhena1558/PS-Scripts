# DiskUsageSpace.ps1 README

## Overview

`DiskUsageSpace.ps1` is a PowerShell script designed to provide detailed information about disk space usage on your system. The script calculates and displays the total size, used space, and free space for each drive.

## Script Details

The script defines and runs a function called `Get-DiskSpaceUsage`, which performs the following actions:
1. Retrieves all file system drives using `Get-PSDrive` with the `FileSystem` provider.
2. Iterates through each drive to calculate the used space, free space, and total size in gigabytes (GB).
3. Outputs the disk space usage information for each drive in a readable format.

### Script Code
```powershell
# Function to get disk space usage
function Get-DiskSpaceUsage {
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        $drive = $_
        $total = [math]::round($drive.Used / 1GB, 2)
        $free = [math]::round($drive.Free / 1GB, 2)
        $totalSize = [math]::round($drive.Used / 1GB + $drive.Free / 1GB, 2)
        Write-Output "Drive $($drive.Name): Total Size: ${totalSize}GB, Used: ${total}GB, Free: ${free}GB"
    }
}

# Run the function
Get-DiskSpaceUsage
```

## Prerequisites

- Windows Operating System
- PowerShell installed

## Usage

### Steps to Run the Script

1. **Open PowerShell as Administrator**
   - It is recommended to run this script with administrative privileges to ensure accurate reporting of disk space usage.

2. **Navigate to the Script Directory**
   - Change the directory to where `DiskUsageSpace.ps1` is located. For example:
     ```powershell
     cd "C:\Path\To\Your\Script"
     ```

3. **Execute the Script**
   - Run the script by typing:
     ```powershell
     .\DiskUsageSpace.ps1
     ```

### Example Output

The script will display output similar to the following:
```
Drive C: Total Size: 476.94GB, Used: 123.45GB, Free: 353.49GB
Drive D: Total Size: 931.51GB, Used: 456.78GB, Free: 474.73GB
```

## Important Notes

- Ensure your execution policy allows the running of scripts. If not, you can set the execution policy to allow script execution by running the following command in PowerShell:
  ```powershell
  Set-ExecutionPolicy RemoteSigned
  ```

## Troubleshooting

- **Permission Issues**: If you encounter permission issues, make sure to run PowerShell as an administrator.
- **Execution Policy**: If scripts are blocked, verify and set the correct execution policy using:
  ```powershell
  Get-ExecutionPolicy
  Set-ExecutionPolicy RemoteSigned
  ```

## Contact

For further assistance or to report issues, please contact Ian.Peto@Broadcom.com.

---

This README file provides essential information on how to use and troubleshoot the `DiskUsageSpace.ps1` PowerShell script. If you have any further questions, please feel free to reach out.
