# NewUserCreation-AD
Checks and imports modules, prompts for creds, creates new user, runs Delta Sync, adds Business Prem License. 
Make sure to replace "example" in the script with your actual domain or tenant name. Also, ensure that you have the required modules (AzureAD, AzureADPreview, and MSOnline) installed on your system. If any of these modules are missing, the script will attempt to import them using Import-Module.

Please note that this script assumes you have the necessary permissions and access to the Active Directory and Microsoft 365 services to perform the user creation, licensing, and synchronization operations.