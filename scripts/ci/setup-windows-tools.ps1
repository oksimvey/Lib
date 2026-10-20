# Windows PowerShell 5.1+; invoked only by trusted master branch jobs.
# Downloads version-locked releases from the authors and validates official SHA256.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not $env:GITHUB_PATH) { throw 'Run through GitHub Actions (GITHUB_PATH missing).' }
if (-not $env:RUNNER_TEMP) { throw 'RUNNER_TEMP missing.' }

$cacheBase = if ($env:RUNNER_TOOL_CACHE) { $env:RUNNER_TOOL_CACHE } else { $env:LOCALAPPDATA }
if (-not $cacheBase) { throw 'RUNNER_TOOL_CACHE and LOCALAPPDATA are both missing.' }
$cacheRoot = Join-Path $cacheBase 'starless-pinned-tools'
New-Item -ItemType Directory -Force -Path $cacheRoot | Out-Null

function Get-PinnedToolDirectory {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Version,
        [Parameter(Mandatory=$true)][string]$Url,
        [Parameter(Mandatory=$true)][string]$Sha256,
        [Parameter(Mandatory=$true)][string]$Executable
    )

    $destination = Join-Path $cacheRoot "$Name-$Version"
    if (Test-Path -LiteralPath $destination) {
        $existing = Get-ChildItem -LiteralPath $destination -Recurse -File -Filter $Executable -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($existing) {
            Write-Host "Using cached $Name $Version"
            return Split-Path -Parent $existing.FullName
        }
        Remove-Item -LiteralPath $destination -Recurse -Force
    }

    $archive = Join-Path $env:RUNNER_TEMP "$Name-$Version-$PID.zip"
    try {
        Write-Host "Downloading SHA-256-verified $Name $Version..."
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Url -OutFile $archive -UseBasicParsing
        $actual = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash
        if ($actual -ine $Sha256) {
            throw "$Name checksum mismatch: expected $Sha256, got $actual"
        }
        Expand-Archive -LiteralPath $archive -DestinationPath $destination -Force
        $binary = Get-ChildItem -LiteralPath $destination -Recurse -File -Filter $Executable | Select-Object -First 1
        if (-not $binary) { throw "$Name archive did not contain $Executable" }
        return Split-Path -Parent $binary.FullName
    } finally {
        if (Test-Path -LiteralPath $archive) {
            Remove-Item -LiteralPath $archive -Force
        }
    }
}

# Exact SHA-256 digests from the upstream GitHub release assets.
$rojo = Get-PinnedToolDirectory -Name 'rojo' -Version '7.7.0-win-x64' -Url 'https://github.com/rojo-rbx/rojo/releases/download/v7.7.0/rojo-7.7.0-windows-x86_64.zip' -Sha256 '2179c44862a10ecbd725bdfeb4abc64e16dc4aad9b6c8f3e1a7c46a87280b949' -Executable 'rojo.exe'
$luau = Get-PinnedToolDirectory -Name 'luau' -Version '0.742-win-x64' -Url 'https://github.com/luau-lang/luau/releases/download/0.742/luau-windows.zip' -Sha256 '1114966cd8198f407069f07e8b4e6bacf2ded933e4a57d6ddc75617969278c75' -Executable 'luau-compile.exe'

if (-not (Test-Path -LiteralPath (Join-Path $luau 'luau.exe'))) {
    throw 'The pinned Luau archive is missing luau.exe.'
}

Add-Content -LiteralPath $env:GITHUB_PATH -Value $rojo -Encoding UTF8
Add-Content -LiteralPath $env:GITHUB_PATH -Value $luau -Encoding UTF8
& (Join-Path $rojo 'rojo.exe') --version
if ($LASTEXITCODE -ne 0) { throw 'Rojo did not start on this Windows runner.' }
Write-Host 'Pinned tools installed and available in subsequent workflow steps.'
