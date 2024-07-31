# Function to display network configuration
function Get-NetworkConfiguration {
    Get-NetIPConfiguration | Format-Table -AutoSize
}

# Run the function
Get-NetworkConfiguration
