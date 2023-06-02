# Define the download URL and destination file path
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$chromeInstallerPath = "$env:TEMP\chrome_installer.exe"

# Download the Chrome installer
Invoke-WebRequest -Uri $chromeUrl -OutFile $chromeInstallerPath

# Install Google Chrome silently
$installArgs = "/silent /install"
Start-Process -FilePath $chromeInstallerPath -ArgumentList $installArgs -Wait

# Clean up the temporary installer file
Remove-Item -Path $chromeInstallerPath