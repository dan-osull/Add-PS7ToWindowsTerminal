$terminalFolderPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
# Get Windows Terminal settings file
$settingsFilePath = Join-Path $terminalFolderPath 'profiles.json'
$json = Get-Content $settingsFilePath | ConvertFrom-Json
# Get PS Core profile
$profiles = $json.profiles
$psCore = $profiles | Where-Object {$_.name -eq 'PowerShell Core'}
# Make a copy of profile and configure for PS7 x64
$ps7 = $psCore.psobject.Copy()
$ps7.name = 'PowerShell 7-preview (x64)'
$ps7.commandline = 'C:\Program Files\PowerShell\7-preview\pwsh.exe'
$ps7.guid = '{' + (New-Guid).ToString() + '}'
# Download and set icon
$pwsh7IconPath = Join-Path $terminalFolderPath 'pwsh7.ico'
Invoke-WebRequest -Uri 'https://blog.osull.com/wp-content/uploads/2019/06/pwsh_32512.ico' -OutFile $pwsh7IconPath
$ps7.icon = $pwsh7IconPath
# Write updated settings file
$json.profiles = $profiles + $ps7
$json | ConvertTo-Json | Out-File $settingsFilePath