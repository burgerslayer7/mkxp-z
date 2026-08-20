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
    return $null
}

function Copy-DirectoryContents {
    param([string]$Source, [string]$Destination)

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null

    $resolvedSource = (Resolve-Path -LiteralPath $Source).Path.TrimEnd('\')
    $resolvedDestination = $null
    if (Test-Path -LiteralPath $Destination) {
        $resolvedDestination = (Resolve-Path -LiteralPath $Destination).Path.TrimEnd('\')
    }
    if ($resolvedDestination -and $resolvedSource -ieq $resolvedDestination) {
        return
    }

    $robocopy = Get-Command robocopy.exe -ErrorAction SilentlyContinue
    if ($robocopy) {
        & $robocopy.Source $Source $Destination /E /COPY:DAT /DCOPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP | Out-Host
        if ($LASTEXITCODE -gt 7) {
            throw "robocopy failed with exit code $LASTEXITCODE"
        }
        return
    }

    Get-ChildItem -LiteralPath $Source -Force | Copy-Item -Destination $Destination -Recurse -Force
}

$source = (Resolve-Path -LiteralPath $GamePath).Path
$sd = (Resolve-Path -LiteralPath $SdRoot).Path
$gameIni = Join-Path $source 'Game.ini'

if (-not (Test-Path -LiteralPath $gameIni)) {
    throw "Game.ini was not found. RGSS-NX targets RPG Maker XP/VX/VX Ace games (including Pokémon Essentials). PSDK uses the separate PSDK-NX runtime."
}

if ($Profile -eq 'auto') {
    $gameIniText = Get-Content -LiteralPath $gameIni -Raw
    if ($gameIniText -match '(?i)infinite\s*fusion|infinitefusion') {
        $Profile = 'infinite-fusion-2'
    } else {
        $Profile = 'generic-rmxp'
    }
}

$runtimeRoot = Join-Path $sd 'switch\RGSS-NX'
foreach ($dir in @('games', 'saves', 'states', 'screenshots', 'recordings', 'logs', 'config', 'system')) {
    New-Item -ItemType Directory -Force -Path (Join-Path $runtimeRoot $dir) | Out-Null
}

# GitHub Actions artifacts contain a ready-to-copy SD payload (NROs + system scripts).
$payload = Join-Path $PSScriptRoot 'sd'
if (Test-Path -LiteralPath $payload) {
    Write-Host '[RGSS-NX] Installing runtime payload on SD...'
    Copy-DirectoryContents -Source $payload -Destination $sd
}

# Source-tree usage is also supported: install the compatibility preload directly.
$bootstrap = Resolve-PackageFile @(
    (Join-Path $PSScriptRoot 'compat\preload\rgss_nx_bootstrap.rb'),
    (Join-Path $PSScriptRoot '..\..\rgss-nx\compat\preload\rgss_nx_bootstrap.rb')
)
if ($bootstrap) {
    $preloadTarget = Join-Path $runtimeRoot 'system\mkxp-z\Scripts\Preload'
    New-Item -ItemType Directory -Force -Path $preloadTarget | Out-Null
    Copy-Item -LiteralPath $bootstrap -Destination (Join-Path $preloadTarget 'rgss_nx_bootstrap.rb') -Force
}

$targetName = if ($Profile -eq 'infinite-fusion-2') {
    'InfiniteFusion2'
} else {
    $leaf = Split-Path -Leaf $source
    if ([string]::IsNullOrWhiteSpace($leaf)) { 'Game' } else { $leaf }
}
$target = Join-Path (Join-Path $runtimeRoot 'games') $targetName

Write-Host "[RGSS-NX] Copying user game to $target"
Copy-DirectoryContents -Source $source -Destination $target

# Do not inject or overwrite Game.ini/mkxp.json. The mkxp-z core reads the
# fangame's original configuration after mounting the directory selected here.
$content = Join-Path $target 'Game.ini'
if (-not (Test-Path -LiteralPath $content)) {
    throw "The copied game is missing Game.ini at $content"
}

$scripts = Join-Path $target 'Data\Scripts.rxdata'
if (-not (Test-Path -LiteralPath $scripts)) {
    Write-Warning "Data\Scripts.rxdata was not found. The game may use an uncommon RGSS layout; try the generic RGSS-NX browser and keep the resulting log."
}

$genericNro = Join-Path $runtimeRoot 'RGSS-NX.nro'
$if2Nro = Join-Path $runtimeRoot 'RGSS-NX-IF2.nro'
if (-not (Test-Path -LiteralPath $genericNro)) {
    Write-Warning "RGSS-NX.nro is not installed yet. Run this script from the extracted RGSS-NX-M1-Switch artifact, or copy its sd folder to the SD card."
}

Write-Host ''
Write-Host '[RGSS-NX] Installation complete'
Write-Host "Profile : $Profile"
Write-Host "Game    : $target"
Write-Host "Content : $content"
if ($Profile -eq 'infinite-fusion-2') {
    if (-not (Test-Path -LiteralPath $if2Nro)) {
        Write-Warning 'RGSS-NX-IF2.nro is not installed; the generic NRO can still load Game.ini manually.'
    }
    Write-Host 'Launch  : /switch/RGSS-NX/RGSS-NX-IF2.nro'
} else {
    Write-Host 'Launch  : /switch/RGSS-NX/RGSS-NX.nro, then load the game Game.ini'
}
