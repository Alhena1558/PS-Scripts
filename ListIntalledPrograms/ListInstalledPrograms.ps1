# Function to list installed programs
function Get-InstalledPrograms {
    $installedPrograms = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $installedPrograms += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
    $installedPrograms | Where-Object { $_.DisplayName } | Sort-Object DisplayName
}

# Run the function
Get-InstalledPrograms | Format-Table -AutoSize
