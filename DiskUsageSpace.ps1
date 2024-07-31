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
