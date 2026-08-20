param(
    [Parameter(Mandatory = $true)]
    [string]$SdRoot,

    [Parameter(Mandatory = $true)]
    [string]$NroPath
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$sd = (Resolve-Path $SdRoot).Path
$nro = (Resolve-Path $NroPath).Path

$destApp = Join-Path $sd 'switch/RGSS-NX'
$destSmoke = Join-Path $sd 'rgss-nx/smoke-test'
$destPreload = Join-Path $sd 'retroarch/system/mkxp-z/Scripts/Preload'

New-Item -ItemType Directory -Force -Path $destApp, $destSmoke, $destPreload | Out-Null

Copy-Item $nro (Join-Path $destApp 'RGSS-NX.nro') -Force
Copy-Item (Join-Path $projectRoot 'rgss-nx/smoke-test/mkxp.json') $destSmoke -Force
Copy-Item (Join-Path $projectRoot 'rgss-nx/smoke-test/smoke.rb') $destSmoke -Force
Copy-Item (Join-Path $projectRoot 'rgss-nx/compat/preload/rgss_nx_bootstrap.rb') $destPreload -Force

Write-Host 'RGSS-NX M0 files copied successfully.'
Write-Host "NRO:       $(Join-Path $destApp 'RGSS-NX.nro')"
Write-Host "Smoke test: $destSmoke"
Write-Host "Preload:    $destPreload"
