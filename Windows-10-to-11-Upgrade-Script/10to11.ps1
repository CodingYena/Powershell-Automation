Add-Type -AssemblyName System.Windows.Forms

# Define the function to show the GUI dialog and collect parameter values
function Show-ParameterDialog {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [string]$LogFilePathLabel,
        
        [Parameter(Mandatory = $true)]
        [string]$ISOUrlLabel,
        
        [Parameter(Mandatory = $true)]
        [string]$MountPathLabel
    )
    
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(500, 200)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    
    $logFilePathLabel = New-Object System.Windows.Forms.Label
    $logFilePathLabel.Text = $LogFilePathLabel
    $logFilePathLabel.Location = New-Object System.Drawing.Point(20, 20)
    $logFilePathLabel.AutoSize = $true
    
    $logFilePathTextBox = New-Object System.Windows.Forms.TextBox
    $logFilePathTextBox.Location = New-Object System.Drawing.Point(200, 20)
    $logFilePathTextBox.Width = 250
    
    $isoUrlLabel = New-Object System.Windows.Forms.Label
    $isoUrlLabel.Text = $ISOUrlLabel
    $isoUrlLabel.Location = New-Object System.Drawing.Point(20, 60)
    $isoUrlLabel.AutoSize = $true
    
    $isoUrlTextBox = New-Object System.Windows.Forms.TextBox
    $isoUrlTextBox.Location = New-Object System.Drawing.Point(200, 60)
    $isoUrlTextBox.Width = 250
    
    $mountPathLabel = New-Object System.Windows.Forms.Label
    $mountPathLabel.Text = $MountPathLabel
    $mountPathLabel.Location = New-Object System.Drawing.Point(20, 100)
    $mountPathLabel.AutoSize = $true
    
    $mountPathTextBox = New-Object System.Windows.Forms.TextBox
    $mountPathTextBox.Location = New-Object System.Drawing.Point(200, 100)
    $mountPathTextBox.Width = 250
    
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(200, 140)
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    
    $form.Controls.Add($logFilePathLabel)
    $form.Controls.Add($logFilePathTextBox)
    $form.Controls.Add($isoUrlLabel)
    $form.Controls.Add($isoUrlTextBox)
    $form.Controls.Add($mountPathLabel)
    $form.Controls.Add($mountPathTextBox)
    $form.Controls.Add($okButton)
    
    $form.AcceptButton = $okButton
    
    $result = $form.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $parameters = @{
            LogFilePath = $logFilePathTextBox.Text
            ISOUrl = $isoUrlTextBox.Text
            MountPath = $mountPathTextBox.Text
        }
        return $parameters
    }
    
    return $null
}

# Show the parameter dialog and collect values
$parameters = Show-ParameterDialog -Title "Upgrade Script Parameters" -LogFilePathLabel "Log File Path:" -ISOUrlLabel "ISO URL:" -MountPathLabel "Mount Path:"
if ($parameters) {
    # Assign the parameter values
    $logFilePath = $parameters.LogFilePath
    $isoUrl = $parameters.ISOUrl
    $mountPath = $parameters.MountPath
    
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
}
