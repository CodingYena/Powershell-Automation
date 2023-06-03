# Define the log file path
$logFilePath = "$env:TEMP\upgrade_log.txt"

# Function to log error messages
function Log-Error {
    param($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $errorLog = "[$timestamp] ERROR: $message"
    $errorLog | Out-File -FilePath $logFilePath -Append
}

try {
    # Download the Windows 11 ISO
    $isoUrl = "https://www.itechtics.com/?dl_id=168"
    $isoPath = "$env:TEMP\Windows11.iso"
    Invoke-WebRequest -Uri $isoUrl -OutFile $isoPath

    # Mount the Windows 11 ISO
    $mountPath = "D:"
    $diskImage = Mount-DiskImage -ImagePath $isoPath -PassThru
    $diskImage | Get-Volume | Get-Partition | Get-Disk | Set-Disk -IsOffline $false
    $diskImage | Get-Volume | Get-Partition | Get-Disk | Set-Disk -IsReadOnly $false

    # Upgrade to Windows 11
    $setupPath = Join-Path -Path $mountPath -ChildPath "setup.exe"
    Start-Process -FilePath $setupPath -ArgumentList "/auto upgrade /DynamicUpdate disable /QuietInstall /ShowOOBE none" -Wait
}
catch {
    $errorMessage = $_.Exception.Message
    Log-Error -message $errorMessage
}

finally {
    # Clean up
    try {
        Dismount-DiskImage -ImagePath $isoPath -ErrorAction Stop
    }
    catch {
        $errorMessage = $_.Exception.Message
        Log-Error -message $errorMessage
    }

    try {
        Remove-Item -Path $isoPath -ErrorAction Stop
    }
    catch {
        $errorMessage = $_.Exception.Message
        Log-Error -message $errorMessage
    }
}
