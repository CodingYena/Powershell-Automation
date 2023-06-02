# Check for required modules and import them if not already imported
$requiredModules = @("AzureAD", "AzureADPreview", "MSOnline")

foreach ($module in $requiredModules) {
    if (-not (Get-Module -Name $module -ListAvailable)) {
        Write-Host "Importing module $module..."
        Import-Module $module -Force
    }
}

# Prompt for username and password using GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$loginForm = New-Object System.Windows.Forms.Form
$loginForm.Text = "User Creation"
$loginForm.Size = New-Object System.Drawing.Size(300, 200)
$loginForm.StartPosition = "CenterScreen"

$labelUsername = New-Object System.Windows.Forms.Label
$labelUsername.Location = New-Object System.Drawing.Point(10, 20)
$labelUsername.Size = New-Object System.Drawing.Size(280, 20)
$labelUsername.Text = "Enter username:"
$loginForm.Controls.Add($labelUsername)

$textboxUsername = New-Object System.Windows.Forms.TextBox
$textboxUsername.Location = New-Object System.Drawing.Point(10, 40)
$textboxUsername.Size = New-Object System.Drawing.Size(260, 20)
$loginForm.Controls.Add($textboxUsername)

$labelPassword = New-Object System.Windows.Forms.Label
$labelPassword.Location = New-Object System.Drawing.Point(10, 70)
$labelPassword.Size = New-Object System.Drawing.Size(280, 20)
$labelPassword.Text = "Enter password:"
$loginForm.Controls.Add($labelPassword)

$textboxPassword = New-Object System.Windows.Forms.TextBox
$textboxPassword.Location = New-Object System.Drawing.Point(10, 90)
$textboxPassword.Size = New-Object System.Drawing.Size(260, 20)
$textboxPassword.PasswordChar = "*"
$loginForm.Controls.Add($textboxPassword)

$buttonOK = New-Object System.Windows.Forms.Button
$buttonOK.Location = New-Object System.Drawing.Point(75, 130)
$buttonOK.Size = New-Object System.Drawing.Size(75, 23)
$buttonOK.Text = "OK"
$buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$loginForm.AcceptButton = $buttonOK
$loginForm.Controls.Add($buttonOK)

$buttonCancel = New-Object System.Windows.Forms.Button
$buttonCancel.Location = New-Object System.Drawing.Point(160, 130)
$buttonCancel.Size = New-Object System.Drawing.Size(75, 23)
$buttonCancel.Text = "Cancel"
$buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$loginForm.CancelButton = $buttonCancel
$loginForm.Controls.Add($buttonCancel)

$result = $loginForm.ShowDialog()

# If OK button is clicked, proceed with user creation and licensing
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $username = $textboxUsername.Text
    $password = $textboxPassword.Text

    # Create new user in Active Directory
    New-ADUser -SamAccountName $username -UserPrincipalName "$username@example.com" -Name $username -GivenName $username.Split(" ")[0] -Surname $username.Split(" ")[1] -Enabled $true -PasswordNeverExpires $true -AccountPassword (ConvertTo-SecureString -String $password -AsPlainText -Force)

    # Perform Delta sync
    Start-ADSyncSyncCycle -PolicyType Delta

    # Add Business Premium license to the new user
    $license = Get-MsolAccountSku | Where-Object {$_.AccountSkuId -like "example:ENTERPRISEPACK_BPREMIUM"}
    Set-MsolUserLicense -UserPrincipalName "$username@example.com" -AddLicenses $license.AccountSkuId
}

# Cleanup the form
$loginForm.Dispose()
