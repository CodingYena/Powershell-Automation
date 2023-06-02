# Define the VM configuration parameters
$VMName = "MyNewVM"
$RAMSizeGB = 8
$DiskSizeGB = 32
$ISOPath = "C:\path\to\windows11.iso"

# Create a new VM
New-VM -Name $VMName -MemoryStartupBytes ($RAMSizeGB * 1GB)

# Create a new virtual hard disk
$VHDPath = "C:\path\to\$VMName.vhdx"
New-VHD -Path $VHDPath -SizeBytes ($DiskSizeGB * 1GB) -Dynamic

# Attach the virtual hard disk to the VM
Add-VMHardDiskDrive -VMName $VMName -Path $VHDPath

# Set the DVD drive to use the Windows 11 ISO
Set-VMDvdDrive -VMName $VMName -Path $ISOPath

# Configure the boot order to start from the DVD drive
Set-VMFirmware -VMName $VMName -FirstBootDevice (Get-VMDvdDrive -VMName $VMName)

# Start the VM
Start-VM -VMName $VMName
