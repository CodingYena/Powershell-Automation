# Download the Windows 11 ISO
$isoUrl = "https://www.itechtics.com/?dl_id=168"
$isoPath = "$env:TEMP\Windows11.iso"
Invoke-WebRequest -Uri $isoUrl -OutFile $isoPath

# Mount the Windows 11 ISO
$mountPath = "D:"
Mount-DiskImage -ImagePath $isoPath -PassThru | Get-Volume | Get-Partition | Get-Disk | Set-Disk -IsOffline $false
Mount-DiskImage -ImagePath $isoPath -PassThru | Get-Volume | Get-Partition | Get-Disk | Set-Disk -IsReadOnly $false

# Upgrade to Windows 11
$setupPath = "$mountPath:\setup.exe"
Start-Process -FilePath $setupPath -ArgumentList "/auto upgrade /DynamicUpdate disable /QuietInstall /ShowOOBE none" -Wait

# Clean up
Dismount-DiskImage -ImagePath $isoPath
Remove-Item -Path $isoPath
