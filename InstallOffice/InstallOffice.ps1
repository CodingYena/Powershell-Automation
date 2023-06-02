# Set the download URL for the Office Suite installer
$installerUrl = "https://path/to/OfficeSuite64BitInstaller.exe"

# Set the path where you want to save the installer
$installerPath = "$env:TEMP\OfficeSuite64BitInstaller.exe"

# Download the Office Suite installer
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Microsoft Office silently
Start-Process -FilePath $installerPath -ArgumentList "/quiet" -Wait

# Clean up the installer file
Remove-Item -Path $installerPath
