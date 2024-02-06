function Update-WingetV {
    param (
        [string]$URL = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'
    )

  Start-Transcript -path C:\Users\Public\winget.log -Append
    $CurrentVersion = winget --Version
    $latestVersion = (Invoke-RestMethod -Uri $URL).tag_name
    if ($CurrentVersion -ge $latestVersion) {
        Write-Host "Winget is up to date, Version is $CurrentVersion"
    } else {
        Write-Host "winget needs to update before running the script. Installing latest version..."

        $wingetDownloadPath = "$env:TEMP\winget.msixbundle" 

        Write-Host "Downloading latest winget-cli version ..."
        $downloadUrl  = (Invoke-RestMethod -Uri $URL).assets | Where-Object { $_.browser_download_url -Match '.msixbundle' } | Select-Object -ExpandProperty browser_download_url
        Invoke-WebRequest -Uri $downloadUrl -Outfile $wingetDownloadPath

        Write-Host "Installing now"
        Invoke-Expression -Command "Add-AppxPackage -Path $wingetDownloadPath"
        Write-Host "winget updated to latest version .. now running Invoke-RestMethod for christitus winutil ... "
    }
}

# Call the Update-WingetV function
Update-WingetV
Stop-Transcript
# Write-Host "Refreshing Env"
# Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
# RefreshEnv

Invoke-WebRequest -Uri https://christitus.com/win | Invoke-Expression
