Hyper-V VM Creation Script

This script allows you to create and configure a Hyper-V virtual machine (VM) using PowerShell and a graphical user interface (GUI). The script checks for the presence of the Hyper-V module, installs it if necessary, downloads the Windows 11 Pro ISO, creates a Hyper-V VM with specified parameters, and starts the VM.
Prerequisites

    PowerShell version 3.0 or later
    Windows operating system with Hyper-V support
    Internet connectivity to download the Windows 11 Pro ISO

Installation and Usage

    Download the script from the repository or copy the script contents into a new file with a .ps1 extension.

    Open a PowerShell session with administrative privileges.

    Set the execution policy to allow running PowerShell scripts. Run the following command in the PowerShell session:

    javascript

Set-ExecutionPolicy RemoteSigned

Navigate to the directory where the script file is located using the cd command.

Run the script by executing the following command:

    .\script.ps1

    The script will check if the Hyper-V module is installed and import it if necessary. It will then proceed to download the Windows 11 Pro ISO if it's not already downloaded.

    A GUI window will appear, allowing you to configure the VM parameters:
        RAM (GB): Enter the amount of RAM to allocate to the VM in gigabytes.
        VHD Storage (GB): Specify the size of the VM's virtual hard disk in gigabytes.
        VM Name: Provide a name for the VM.
        Switch Name: Enter the name of the virtual switch to connect the VM to.

    Click the "Create VM" button to create the Hyper-V VM with the specified parameters. The script will start the VM automatically after creation.

Important Note

    Make sure to replace the placeholder URL "https://example.com/windows11pro.iso" in the DownloadWindows11ISO function with the actual download link for the Windows 11 Pro ISO. Ensure that the download link is valid and accessible.

License

This script is released under the MIT License. Feel free to modify and distribute it according to your requirements.
