# ListInstalledPrograms.ps1 - README

## Overview
The `ListInstalledPrograms.ps1` script is a PowerShell script designed to list all installed programs on a Windows system. It retrieves information about installed programs from the Windows Registry and displays details such as the program name, version, publisher, and installation date.

## Features
- Lists installed programs from both 32-bit and 64-bit registry locations.
- Retrieves program name, version, publisher, and installation date.
- Outputs the list of installed programs in a formatted table.

## Requirements
- Windows PowerShell
- Administrator privileges (recommended for accurate results)

## Usage
1. **Download the Script**: Save the script to a desired location on your computer with the name `ListInstalledPrograms.ps1`.
2. **Run the Script**: Open PowerShell with administrator privileges and navigate to the directory where the script is saved. Run the script by typing:
   ```powershell
   .\ListInstalledPrograms.ps1
   ```

## Script Explanation
The script consists of a function `Get-InstalledPrograms` which performs the following steps:

1. **Retrieve 64-bit Installed Programs**: Uses `Get-ItemProperty` to fetch installed programs from the 64-bit registry path.
   ```powershell
   $installedPrograms = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
   ```

2. **Retrieve 32-bit Installed Programs**: Uses `Get-ItemProperty` to fetch installed programs from the 32-bit registry path.
   ```powershell
   $installedPrograms += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
   ```

3. **Filter and Sort Programs**: Filters out entries without a display name and sorts the list by program name.
   ```powershell
   $installedPrograms | Where-Object { $_.DisplayName } | Sort-Object DisplayName
   ```

4. **Run the Function**: Executes the `Get-InstalledPrograms` function and formats the output as a table.
   ```powershell
   Get-InstalledPrograms | Format-Table -AutoSize
   ```

## Notes
- The script retrieves information from the registry, which may require administrator privileges for accurate and complete results.
- The script displays the output in a formatted table for easy readability.
- You can modify the `Select-Object` command to include additional properties if needed.

## Disclaimer
This script is provided as-is without any warranties. Use it at your own risk. The author is not responsible for any damage or issues that may arise from using this script.
