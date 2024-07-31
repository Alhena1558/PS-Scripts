# Function to monitor CPU and memory usage
function Monitor-CPUAndMemoryUsage {
    while ($true) {
        $cpu = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
        $memory = Get-WmiObject Win32_OperatingSystem
        $totalMemory = [math]::round($memory.TotalVisibleMemorySize / 1MB, 2)
        $freeMemory = [math]::round($memory.FreePhysicalMemory / 1MB, 2)
        $usedMemory = $totalMemory - $freeMemory

        Clear-Host
        Write-Output "CPU Load: $cpu%"
        Write-Output "Memory Usage: $usedMemory MB / $totalMemory MB"
        Start-Sleep -Seconds 5
    }
}

# Run the function
Monitor-CPUAndMemoryUsage
