[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$GamePath,

    [Parameter(Mandatory = $true)]
    [string]$SdRoot,

    [ValidateSet('auto', 'infinite-fusion-2', 'generic-rmxp')]
    [string]$Profile = 'auto'
)

$ErrorActionPreference = 'Stop'

function Resolve-PackageFile {
    param([string[]]$Candidates)
    foreach ($candidate in $Candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }
    throw "RGSS-NX package file not found. Checked: $($Candidates -join ', ')"
}

function Copy-DirectoryContents {
    param([string]$Source, [string]$Destination)
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null

    $robocopy = Get-Command robocopy.exe -ErrorAction SilentlyContinue
    if ($robocopy) {
        & $robocopy.Source $Source $Destination /E /COPY:DAT /DCOPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP | Out-Host
        if ($LASTEXITCODE -gt 7) {
            throw "robocopy failed with exit code $LASTEXITCODE"
        }
        return
    }

    Copy-Item -LiteralPath (Join-Path $Source '*') -Destination $Destination -Recurse -Force
}

$source = (Resolve-Path -LiteralPath $GamePath).Path
$sd = (Resolve-Path -LiteralPath $SdRoot).Path

if (-not (Test-Path -LiteralPath (Join-Path $source 'Game.ini'))) {
    throw "Game.ini was not found. RGSS-NX currently targets RPG Maker XP/VX/VX Ace games, including Pokémon Essentials. PSDK uses a different runtime and is not handled by this installer yet."
}

if ($Profile -eq 'auto') {
    $gameIni = Get-Content -LiteralPath (Join-Path $source 'Game.ini') -Raw
    if ($gameIni -match '(?i)infinite\s*fusion|infinitefusion') {
        $Profile = 'infinite-fusion-2'
    } else {
        $Profile = 'generic-rmxp'
    }
}

$runtimeRoot = Join-Path $sd 'switch\RGSS-NX'
foreach ($dir in @('games', 'saves', 'states', 'screenshots', 'recordings', 'logs', 'config', 'system')) {
    New-Item -ItemType Directory -Force -Path (Join-Path $runtimeRoot $dir) | Out-Null
}

# If this script came from the GitHub Actions artifact, install the NRO payload too.
$payload = Join-Path $PSScriptRoot 'sd'
if (Test-Path -LiteralPath $payload) {
    Copy-DirectoryContents -Source $payload -Destination $sd
}

$targetName = if ($Profile -eq 'infinite-fusion-2') { 'InfiniteFusion2' } else {
    $leaf = Split-Path -Leaf $source
    if ([string]::IsNullOrWhiteSpace($leaf)) { 'Game' } else { $leaf }
}
$target = Join-Path (Join-Path $runtimeRoot 'games') $targetName

Write-Host "[RGSS-NX] Copying game to $target"
Copy-DirectoryContents -Source $source -Destination $target

$bootstrap = Resolve-PackageFile @(
    (Join-Path $PSScriptRoot 'compat\preload\rgss_nx_bootstrap.rb'),
    (Join-Path $PSScriptRoot '..\..\rgss-nx\compat\preload\rgss_nx_bootstrap.rb')
)
$postload = Resolve-PackageFile @(
    (Join-Path $PSScriptRoot 'compat\postload\rgss_nx_compat.rb'),
    (Join-Path $PSScriptRoot '..\..\rgss-nx\compat\postload\rgss_nx_compat.rb')
)
$profileConfig = Resolve-PackageFile @(
    (Join-Path $PSScriptRoot "profiles\$Profile\RGSSNX.mkxp.json"),
    (Join-Path $PSScriptRoot "..\..\rgss-nx\profiles\$Profile\RGSSNX.mkxp.json")
)

$compatTarget = Join-Path $target 'RGSSNX\compat'
New-Item -ItemType Directory -Force -Path $compatTarget | Out-Null
Copy-Item -LiteralPath $bootstrap -Destination (Join-Path $compatTarget 'rgss_nx_bootstrap.rb') -Force
Copy-Item -LiteralPath $postload -Destination (Join-Path $compatTarget 'rgss_nx_compat.rb') -Force
Copy-Item -LiteralPath $profileConfig -Destination (Join-Path $target 'RGSSNX.mkxp.json') -Force

$scripts = Join-Path $target 'Data\Scripts.rxdata'
if (-not (Test-Path -LiteralPath $scripts)) {
    Write-Warning "Data\Scripts.rxdata was not found. The game may use an uncommon RGSS layout; use the generic RGSS-NX browser first."
}

Write-Host ""
Write-Host "[RGSS-NX] Installation complete"
Write-Host "Profile : $Profile"
Write-Host "Game    : $target"
Write-Host "Content : $(Join-Path $target 'RGSSNX.mkxp.json')"
if ($Profile -eq 'infinite-fusion-2') {
    Write-Host "Launch  : /switch/RGSS-NX/RGSS-NX-IF2.nro"
} else {
    Write-Host "Launch  : /switch/RGSS-NX/RGSS-NX.nro, then load RGSSNX.mkxp.json"
}
