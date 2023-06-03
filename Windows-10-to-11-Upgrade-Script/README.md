Upgrade Script

This script allows you to perform a Windows 11 upgrade using a GUI dialog to collect the necessary parameters.
Prerequisites

    PowerShell 5.1 or later
    Windows PowerShell ISE or any other PowerShell editor
    Windows 11 ISO file or URL

Usage

    Open PowerShell and run the script.

    powershell

    .\upgrade-script.ps1

    The script will display a GUI dialog to collect the following parameters:
        Log File Path: The path to the log file where the script will log messages and errors.
        ISO URL: The URL or file path to the Windows 11 ISO file.
        Mount Path: The path where the Windows 11 ISO will be mounted.

    Click the "OK" button to proceed with the upgrade.

Script Details

The script consists of the following main components:

    Show-ParameterDialog: This function displays a GUI dialog to collect the necessary parameters from the user.

    Log-Message: This function logs messages to the specified log file.

    Log-Error: This function logs error messages to the specified log file.

    The main script logic performs the following steps:
        Validates the existence and writability of the log file path.
        Validates the provided ISO URL.
        Downloads the Windows 11 ISO file from the provided URL.
        Verifies the existence of the mount path.
        Mounts the Windows 11 ISO image.
        Performs the Windows 11 upgrade using the mounted ISO.
        Logs success or error messages depending on the outcome of the upgrade.
        Cleans up by dismounting the ISO and removing the temporary ISO file.

Notes

    Ensure that you have the necessary permissions to access and modify the log file, mount path, and perform the Windows 11 upgrade.
    The script requires an active internet connection to download the Windows 11 ISO if a URL is provided.

Feel free to modify the script to suit your specific requirements.

Disclaimer: Use this script at your own risk. Ensure that you have proper backups and understand the potential implications of upgrading to Windows 11.

If you have any issues or questions, please feel free to open an issue in this GitHub repository.

Enjoy upgrading to Windows 11!
