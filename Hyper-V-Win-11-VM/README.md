# Hyper-V-Win-11-VM
Creates a Win 11 VM with 8gb of RAM, 32GB Vhd via Hyper-V

Certainly! Here's a PowerShell script to create a new Hyper-V virtual machine with the specified configuration:

powershell

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

Make sure to replace the following parameters with your own values:

    $VMName: The desired name for your new virtual machine.
    $RAMSizeGB: The amount of RAM (in gigabytes) to allocate to the virtual machine.
    $DiskSizeGB: The desired size of the virtual hard disk (in gigabytes).
    $ISOPath: The file path to the Windows 11 ISO file.

This script creates a new Hyper-V virtual machine with the specified name, sets the RAM size, creates a new dynamically expanding virtual hard disk, attaches the virtual hard disk to the virtual machine, sets the DVD drive to use the Windows 11 ISO file, configures the boot order to start from the DVD drive, and finally starts the virtual machine.

Please note that this script assumes you have Hyper-V installed and have the necessary permissions to create and configure virtual machines.

