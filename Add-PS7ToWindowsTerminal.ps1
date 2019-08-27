$terminalFolderPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
# Get Windows Terminal settings file
$settingsFilePath = Join-Path $terminalFolderPath 'profiles.json'
$json = Get-Content $settingsFilePath | ConvertFrom-Json
# Get PS Core profile
$profiles = $json.profiles
# Make a copy of first profile and configure for PS7 x64
$ps7 = $profiles[0].psobject.Copy()
$ps7.name = 'PowerShell 7-preview (x64)'
$ps7.commandline = 'C:\Program Files\PowerShell\7-preview\pwsh.exe'
$ps7.guid = '{' + (New-Guid).ToString() + '}'
# Download and set icon
$pwsh7IconPath = Join-Path $terminalFolderPath 'pwsh7.ico'
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/weebsnore/Add-PS7ToWindowsTerminal/master/pwsh7.ico' -OutFile $pwsh7IconPath
$ps7.icon = $pwsh7IconPath
# Write updated settings file
$json.profiles = $profiles + $ps7
$json | ConvertTo-Json | Out-File $settingsFilePath