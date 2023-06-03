# Define the log file path
$logFilePath = "$env:TEMP\upgrade_log.txt"

# Define the ISO URL
$isoUrl = "https://www.itechtics.com/?dl_id=168"

# Define the mount path
$mountPath = "D:"

# Function to log messages
function Log-Message {
    param($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $message"
    $logEntry | Out-File -FilePath $logFilePath -Append
}

# Function to log error messages
function Log-Error {
    param($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $errorLog = "[$timestamp] ERROR: $message"
    $errorLog | Out-File -FilePath $logFilePath -Append
}

try {
    # Validate the existence and writability of the log file path
    $logDirectory = Split-Path -Path $logFilePath -Parent

    if (-not (Test-Path -Path $logDirectory)) {
        throw "Log directory does not exist: $logDirectory"
    }

    if (-not (Test-Path -Path $logFilePath -PathType Leaf)) {
        # Create an empty log file if it doesn't exist
        $null | Out-File -FilePath $logFilePath
    }

    # Validate the ISO URL
    $isoUri = [System.Uri]::new($isoUrl)
    if (-not $isoUri.IsWellFormedOriginalString()) {
        throw "Invalid ISO URL: $isoUrl"
    }

    # Download the Windows 11 ISO
    try {
        $response = Invoke-WebRequest -Uri $isoUrl -MaximumRedirection 10
        $finalUrl = $response.BaseResponse.ResponseUri.AbsoluteUri
        $isoPath = "$env:TEMP\Windows11.iso"
        Invoke-WebRequest -Uri $finalUrl -OutFile $isoPath
    }
    catch {
        $errorMessage = $_.Exception.Message
        Log-Error -message $errorMessage
        throw
    }

    # Verify the mount path
    if (-not (Test-Path -Path $mountPath)) {
        throw "Mount path does not exist: $mountPath"
    }

    # Mount the Windows 11 ISO
    $diskImage = Mount-DiskImage -ImagePath $isoPath -PassThru
    $diskImage | Get-Volume | Get-Partition | Get-Disk | Set-Disk -IsOffline $false
    $diskImage | Get-Volume | Get-Partition | Get-Disk | Set-Disk -IsReadOnly $false

    # Upgrade to Windows 11
    $setupPath = Join-Path -Path $mountPath -ChildPath "setup.exe"
    Start-Process -FilePath $setupPath -ArgumentList "/auto upgrade /DynamicUpdate disable /QuietInstall /ShowOOBE none" -Wait

    # Log success message
    Log-Message "Windows 11 upgrade completed successfully"
}
catch {
    $errorMessage = $_.Exception.Message
    Log-Error -message $errorMessage
}
finally {
    # Clean up
    try {
        if ($isoPath -and (Test-Path -Path $isoPath -PathType Leaf)) {
            Dismount-DiskImage -ImagePath $isoPath -ErrorAction Stop
            Remove-Item -Path $isoPath -ErrorAction Stop
        }
    }
    catch {
        $errorMessage = $_.Exception.Message
        Log-Error -message $errorMessage
    }
}
