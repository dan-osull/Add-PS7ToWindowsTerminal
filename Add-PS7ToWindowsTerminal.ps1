# Get Windows Terminal settings
$terminalFolderPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$settingsFilePath = Join-Path $terminalFolderPath 'profiles.json'
[System.Collections.ArrayList]$settings = Get-Content $settingsFilePath
# Download icon
$pwsh7IconPath = Join-Path $terminalFolderPath 'pwsh7.ico'
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/weebsnore/Add-PS7ToWindowsTerminal/master/pwsh7.ico' -OutFile $pwsh7IconPath
# Generate PS7 profile JSON
$ps7profile = @{
    'guid' = '{' + (New-Guid).ToString() + '}'
    'name' = 'PowerShell 7-preview (x64)'
    'commandline' = 'C:\Program Files\PowerShell\7-preview\pwsh.exe'
    'icon' = $pwsh7IconPath
} | ConvertTo-Json
# Append comma to profile JSON
$ps7profile = $ps7profile + ','
# Find "profiles" line number
$profilesLine = ($settings | Select-String '"profiles":').LineNumber
# Add new profile to JSON and write to disk
,$settings.Insert($profilesLine+1,$ps7profile)
$settings | Out-File $settingsFilePath
