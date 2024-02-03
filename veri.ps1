function Update-WingetV {
    param (
        [string]$Url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'
    )

 
    $latestRelease = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"
    $latestVersion = $latestRelease.tag_name
    $userHomeDirectory = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
    $CurrentVersion = winget --Version
    if ($CurrentVersion -ge $latestVersion) {
        Write-Host "Winget is up to date, Version is $CurrentVersion"
    } else {
        Write-Host "winget needs to update before running the script. Installing latest version..."

        $downloadUrl = $latestRelease.assets[0].browser_download_url

        $wingetDownloadPath = "$userHomeDirectory"

        Write-Host "Donwloading latest winget-cli version ..."
        Invoke-RestMethod -Uri $downloadUrl -OutFile $wingetDownloadPath
        Hide-Spinner

        Write-Host "Installing now"
        Invoke-Expression -Command "Add-AppxPackage -Path $wingetDownloadPath"
        Write-Host "winget updated to latest version"
    }
}






$GitHubRepoOwner = "microsoft"
$GitHubRepoName = "winget-cli"

Update-WingetV -GitHubRepoOwner $GitHubRepoOwner -GitHubRepoName $GitHubRepoName

Write-Host "Refreshing Env"
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
RefreshEnv

Invoke-WebRequest -Uri https://christitus.com/win | Invoke-Expression
