Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Check if Hyper-V module is installed and import it if not
if (-not (Get-Module -ListAvailable -Name Hyper-V)) {
    Write-Host "Hyper-V module not found. Importing..."
    Import-Module Hyper-V
}

# Function to check and install Hyper-V
function InstallHyperV {
    try {
        Write-Host "Checking if Hyper-V is installed..."
        $hyperVInstalled = Get-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V-All" -Online | Select-Object -ExpandProperty State

        if ($hyperVInstalled -ne "Enabled") {
            Write-Host "Hyper-V is not enabled. Enabling..."
            Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V-All" -Online -All -NoRestart
        }
        else {
            Write-Host "Hyper-V is already enabled."
        }
    }
    catch {
        Write-Host "Error installing Hyper-V: $_"
    }
}

# Function to check and download Windows 11 Pro ISO
function DownloadWindows11ISO {
    try {
        $isoPath = "C:\Windows11Pro.iso"

        if (-not (Test-Path $isoPath)) {
            Write-Host "Downloading Windows 11 Pro ISO..."
            $url = "https://example.com/windows11pro.iso"  # Replace with the actual download link

            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($url, $isoPath)
        }
        else {
            Write-Host "Windows 11 Pro ISO already downloaded."
        }
    }
    catch {
        Write-Host "Error downloading Windows 11 Pro ISO: $_"
    }
}

# Function to create the Hyper-V VM
function CreateVM {
    param($ram, $storage, $vmName, $switchName)

    try {
        Write-Host "Creating Hyper-V VM..."
        New-VM -Name $vmName -MemoryStartupBytes ($ram * 1GB) -Path "C:\VMs" -NewVHDPath "C:\VMs\$vmName.vhdx" -NewVHDSizeBytes ($storage * 1GB) -SwitchName $switchName -Generation 2
        Set-VMDvdDrive -VMName $vmName -Path "C:\Windows11Pro.iso"
        Set-VMProcessor -VMName $vmName -Count 2
        Set-VMMemory -VMName $vmName -DynamicMemoryEnabled $true -MaximumBytes ($ram * 1GB) -MinimumBytes ($ram * 1GB)
        Write-Host "Hyper-V VM created successfully."
    }
    catch {
        Write-Host "Error creating Hyper-V VM: $_"
    }
}

# Function to start the Hyper-V VM
function StartVM {
    param($vmName)

    try {
        Write-Host "Starting Hyper-V VM..."
        Start-VM -Name $vmName
        Write-Host "Hyper-V VM started successfully."
    }
    catch {
        Write-Host "Error starting Hyper-V VM: $_"
    }
}

# Check and install Hyper-V
InstallHyperV

# Check and download Windows 11 Pro ISO
DownloadWindows11ISO

# GUI Configuration
$form = New-Object System.Windows.Forms.Form
$form.Text = "Hyper-V VM Creation"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"

$labelRAM = New-Object System.Windows.Forms.Label
$labelRAM.Location = New-Object System.Drawing.Point(10, 20)
$labelRAM.Size = New-Object System.Drawing.Size(100, 20)
$labelRAM.Text = "RAM (GB):"
$form.Controls.Add($labelRAM)

$inputRAM = New-Object System.Windows.Forms.TextBox
$inputRAM.Location = New-Object System.Drawing.Point(120, 20)
$inputRAM.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($inputRAM)

$labelStorage = New-Object System.Windows.Forms.Label
$labelStorage.Location = New-Object System.Drawing.Point(10, 50)
$labelStorage.Size = New-Object System.Drawing.Size(100, 20)
$labelStorage.Text = "VHD Storage (GB):"
$form.Controls.Add($labelStorage)

$inputStorage = New-Object System.Windows.Forms.TextBox
$inputStorage.Location = New-Object System.Drawing.Point(120, 50)
$inputStorage.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($inputStorage)

$labelVMName = New-Object System.Windows.Forms.Label
$labelVMName.Location = New-Object System.Drawing.Point(10, 80)
$labelVMName.Size = New-Object System.Drawing.Size(100, 20)
$labelVMName.Text = "VM Name:"
$form.Controls.Add($labelVMName)

$inputVMName = New-Object System.Windows.Forms.TextBox
$inputVMName.Location = New-Object System.Drawing.Point(120, 80)
$inputVMName.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($inputVMName)

$labelSwitchName = New-Object System.Windows.Forms.Label
$labelSwitchName.Location = New-Object System.Drawing.Point(10, 110)
$labelSwitchName.Size = New-Object System.Drawing.Size(100, 20)
$labelSwitchName.Text = "Switch Name:"
$form.Controls.Add($labelSwitchName)

$inputSwitchName = New-Object System.Windows.Forms.TextBox
$inputSwitchName.Location = New-Object System.Drawing.Point(120, 110)
$inputSwitchName.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($inputSwitchName)

$buttonCreate = New-Object System.Windows.Forms.Button
$buttonCreate.Location = New-Object System.Drawing.Point(10, 140)
$buttonCreate.Size = New-Object System.Drawing.Size(120, 30)
$buttonCreate.Text = "Create VM"
$buttonCreate.Add_Click({
    CreateVM $inputRAM.Text $inputStorage.Text $inputVMName.Text $inputSwitchName.Text
    StartVM $inputVMName.Text
})
$form.Controls.Add($buttonCreate)

# Start the GUI
$form.ShowDialog() | Out-Null
