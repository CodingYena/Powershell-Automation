Chrome Installer Script

This script automates the download and silent installation of Google Chrome using PowerShell. It provides a convenient way to install Chrome on your system without requiring manual intervention.
Prerequisites

    PowerShell: Ensure that you have PowerShell installed on your system.

Usage

    Download the script to your local machine or clone the repository.

    Open a PowerShell terminal or PowerShell Integrated Scripting Environment (ISE).

    Navigate to the directory where the script is located.

    Execute the script by running the following command:

    powershell

.\chrome_installer.ps1

Note: If you encounter an error related to the execution policy, you might need to change the execution policy to allow running PowerShell scripts. Run the following command in an elevated PowerShell session:

powershell

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

    Choose "Y" or "A" to confirm the change.

    The script will download the latest version of the Google Chrome installer from the official URL specified in the $chromeUrl variable. It will save the installer to a temporary location on your system ($env:TEMP\chrome_installer.exe).

    Once the download is complete, the script will silently install Google Chrome using the downloaded installer. The installation is performed using the /silent /install arguments.

    After the installation is finished, the temporary installer file will be automatically removed from your system.

Customization

    If you prefer to change the download URL or specify a different destination path for the installer, modify the $chromeUrl and $chromeInstallerPath variables at the beginning of the script.

    If you wish to customize the installation process, you can modify the $installArgs variable. Refer to the Google Chrome documentation for available command-line options.

License

This script is released under the MIT License. Feel free to modify and distribute it according to your needs.
Disclaimer

Please note that this script is provided as-is and without any warranty. Use it at your own risk. The script author and the contributors cannot be held responsible for any damage or loss resulting from its use. Always verify the script's content and test it in a safe environment before running it on a production system.
