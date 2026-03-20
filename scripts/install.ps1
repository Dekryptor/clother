# PowerShell Windows Installer Script for Go

# Define the URL for the Go binary
$goUrl = "https://golang.org/dl/go1.17.5.windows-amd64.msi"

# Define the location to install Go
$installLocation = "C:\Go"

# Download the Go installer
$installer = "C:\Temp\go-installer.msi"
Invoke-WebRequest -Uri $goUrl -OutFile $installer

# Install Go
Start-Process msiexec.exe -ArgumentList "/i $installer /quiet ADDLOCAL=InstallDir /L*v C:\Temp\go-install.log /norestart INSTALLDIR=$installLocation" -Wait

# Remove the installer file after installation
Remove-Item $installer

# Create wrapper batch files for each provider
$providers = @("provider1", "provider2")
foreach ($provider in $providers) {
    $batchFile = "C:\Go\bin\$provider.bat"
    Set-Content -Path $batchFile -Value "@echo off`nset PATH=%PATH%;C:\Go\bin`n$provider %*"
}

# Set environment variables
[System.Environment]::SetEnvironmentVariable('GOPATH', 'C:\Go', 'Machine')
[System.Environment]::SetEnvironmentVariable('GOROOT', 'C:\Go', 'Machine')

# Update the PATH variable
$envPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
$envPath += ";$installLocation\bin"
[System.Environment]::SetEnvironmentVariable('Path', $envPath, 'Machine')

# Output installation success message
Write-Host "Go installation complete!" -ForegroundColor Green
