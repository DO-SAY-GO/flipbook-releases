$ErrorActionPreference = "Stop"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch { }

$ReleaseRepo = if ($env:FLIPBOOK_RELEASE_REPO) { $env:FLIPBOOK_RELEASE_REPO } else { "DO-SAY-GO/flipbook-releases" }
$RawSelfUrl = if ($env:FLIPBOOK_INSTALL_URL) { $env:FLIPBOOK_INSTALL_URL } else { "https://raw.githubusercontent.com/DO-SAY-GO/flipbook-releases/main/install.ps1" }
$DataRoot = if ($env:FLIPBOOK_DATA_DIR) { $env:FLIPBOOK_DATA_DIR } else { Join-Path $env:LOCALAPPDATA "Programs\FlipBook" }
$InstallDir = if ($env:FLIPBOOK_INSTALL_DIR) { $env:FLIPBOOK_INSTALL_DIR } else { Join-Path $DataRoot "bin" }
$WrapperPath = Join-Path $InstallDir "flipbook.ps1"
$CmdShimPath = Join-Path $InstallDir "flipbook.cmd"
$CliPath = Join-Path $InstallDir "flipbook-cli.exe"
$StateDir = Join-Path $DataRoot "state"
$LastUpdateFile = Join-Path $StateDir "last-update-check.txt"
$InstalledTagFile = Join-Path $StateDir "installed-tag.txt"
$UpdateIntervalSeconds = if ($env:FLIPBOOK_UPDATE_INTERVAL_SECONDS) { [int]$env:FLIPBOOK_UPDATE_INTERVAL_SECONDS } else { 86400 }
$Token = if ($env:GH_TOKEN) { $env:GH_TOKEN } elseif ($env:GITHUB_TOKEN) { $env:GITHUB_TOKEN } else { $null }

function Write-InfoLine {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

function Write-WarnLine {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Get-GitHubHeaders {
    $headers = @{
        "User-Agent" = "FlipBook-Installer"
    }

    if ($Token) {
        $headers["Authorization"] = "Bearer $Token"
    }

    return $headers
}

function Ensure-Directories {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
}

function Get-SemverFromText {
    param([string]$Text)

    $match = [regex]::Match($Text, '(?im)(v?\d+\.\d+(?:\.\d+)?(?:-[0-9A-Za-z\.-]+)?)')
    if ($match.Success) {
        return $match.Groups[1].Value
    }

    return $null
}

function Get-StableTags {
    $uri = "https://api.github.com/repos/$ReleaseRepo/tags?per_page=100"
    $response = Invoke-RestMethod -Uri $uri -Headers (Get-GitHubHeaders) -TimeoutSec 20
    @($response) |
        ForEach-Object { $_.name } |
        Where-Object { $_ -match '^v\d+\.\d+\.\d+$' }
}

function Get-LatestStableTag {
    $bestTag = $null
    $bestVersion = $null

    foreach ($tag in Get-StableTags) {
        $version = [version]($tag.TrimStart("v"))
        if (-not $bestVersion -or $version -gt $bestVersion) {
            $bestVersion = $version
            $bestTag = $tag
        }
    }

    if (-not $bestTag) {
        throw "Could not determine the latest stable FlipBook release."
    }

    return $bestTag
}

function Get-LocalVersionTag {
    if (-not (Test-Path $CliPath)) {
        return "not_installed"
    }

    try {
        $output = & $CliPath --version 2>$null | Out-String
        $version = Get-SemverFromText -Text $output
        if (-not $version) {
            return "unknown"
        }

        if ($version.StartsWith("v")) {
            return $version
        }

        return "v$version"
    } catch {
        return "unknown"
    }
}

function Test-NeedsUpdate {
    param(
        [string]$CandidateTag,
        [string]$CurrentTag
    )

    if ($CurrentTag -in @("unknown", "not_installed")) {
        return $true
    }

    return ([version]($CandidateTag.TrimStart("v")) -gt [version]($CurrentTag.TrimStart("v")))
}

function Record-UpdateCheck {
    Ensure-Directories
    [DateTimeOffset]::UtcNow.ToUnixTimeSeconds().ToString() | Set-Content -Path $LastUpdateFile -Encoding ASCII
}

function Should-CheckForUpdates {
    if ($env:FLIPBOOK_SKIP_UPDATE_CHECK) {
        $normalized = $env:FLIPBOOK_SKIP_UPDATE_CHECK.ToLowerInvariant()
        if ($normalized -in @("1", "true", "yes", "y", "on")) {
            return $false
        }
    }

    if (-not (Test-Path $LastUpdateFile)) {
        return $true
    }

    try {
        $lastCheck = [long]((Get-Content $LastUpdateFile -Raw).Trim())
    } catch {
        return $true
    }

    $now = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    return (($now - $lastCheck) -ge $UpdateIntervalSeconds)
}

function Download-And-InstallBinary {
    param([string]$Tag)

    Ensure-Directories

    $archiveName = "flipbook-$Tag-windows-x64.zip"
    $downloadUrl = "https://github.com/$ReleaseRepo/releases/download/$Tag/$archiveName"
    $tempRoot = Join-Path $env:TEMP ("flipbook-" + [guid]::NewGuid().ToString("N"))
    $archivePath = Join-Path $tempRoot $archiveName
    $extractDir = Join-Path $tempRoot "extract"

    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

    try {
        Write-InfoLine "Installing FlipBook $Tag..."
        Invoke-WebRequest -Uri $downloadUrl -Headers (Get-GitHubHeaders) -OutFile $archivePath -TimeoutSec 60
        Expand-Archive -Path $archivePath -DestinationPath $extractDir -Force

        $binary = Get-ChildItem $extractDir -Recurse -File |
            Where-Object { $_.Name -eq "flipbook.exe" } |
            Select-Object -First 1

        if (-not $binary) {
            throw "Downloaded archive did not contain the FlipBook binary."
        }

        $tmpBinary = "$CliPath.tmp"
        Copy-Item $binary.FullName $tmpBinary -Force
        Move-Item $tmpBinary $CliPath -Force
        $Tag | Set-Content -Path $InstalledTagFile -Encoding ASCII
        [DateTimeOffset]::UtcNow.ToUnixTimeSeconds().ToString() | Set-Content -Path $LastUpdateFile -Encoding ASCII
    } finally {
        Remove-Item $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Ensure-Binary {
    if (-not (Test-Path $CliPath)) {
        $tag = Get-LatestStableTag
        Download-And-InstallBinary -Tag $tag
        return
    }

    if (-not (Should-CheckForUpdates)) {
        return
    }

    Record-UpdateCheck

    try {
        $latestTag = Get-LatestStableTag
        $currentTag = Get-LocalVersionTag
        if (Test-NeedsUpdate -CandidateTag $latestTag -CurrentTag $currentTag) {
            Write-InfoLine "Updating FlipBook to $latestTag..."
            Download-And-InstallBinary -Tag $latestTag
        }
    } catch {
        Write-WarnLine "Update check failed. Continuing with the installed binary."
    }
}

function Add-InstallDirToUserPath {
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $segments = @()

    if ($currentPath) {
        $segments = $currentPath.Split(";") | Where-Object { $_ }
    }

    if ($segments -notcontains $InstallDir) {
        $newPath = if ($currentPath) {
            "$currentPath;$InstallDir"
        } else {
            $InstallDir
        }

        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        $env:Path = "$env:Path;$InstallDir"
        Write-InfoLine "Added $InstallDir to the user PATH."
    }
}

function Install-Wrapper {
    Ensure-Directories

    Invoke-WebRequest -Uri $RawSelfUrl -Headers (Get-GitHubHeaders) -OutFile $WrapperPath -TimeoutSec 30

    @"
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0flipbook.ps1" %*
"@ | Set-Content -Path $CmdShimPath -Encoding ASCII

    Add-InstallDirToUserPath
    Ensure-Binary

    Write-InfoLine "Installed FlipBook to $InstallDir."
    if ($env:Path -notlike "*$InstallDir*") {
        Write-WarnLine "Open a new terminal to pick up the updated PATH."
    }
}

function Test-InstallMode {
    $scriptName = $null

    if ($MyInvocation.MyCommand.Path) {
        $scriptName = [IO.Path]::GetFileName($MyInvocation.MyCommand.Path)
    } elseif ($MyInvocation.MyCommand.Name) {
        $scriptName = [IO.Path]::GetFileName($MyInvocation.MyCommand.Name)
    }

    return ($scriptName -ne "flipbook.ps1")
}

if (Test-InstallMode) {
    Install-Wrapper
    exit 0
}

Ensure-Binary
& $CliPath @args
exit $LASTEXITCODE
