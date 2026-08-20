param(
    [Parameter(Mandatory = $true)]
    [string]$GameRoot
)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path $GameRoot).Path

Write-Host "RGSS-NX game inspection: $root"

$gameIni = Join-Path $root 'Game.ini'
$mkxpJson = Join-Path $root 'mkxp.json'

Write-Host ("Game.ini : " + $(if (Test-Path $gameIni) { 'FOUND' } else { 'missing' }))
Write-Host ("mkxp.json: " + $(if (Test-Path $mkxpJson) { 'FOUND' } else { 'missing' }))

$allFiles = Get-ChildItem -LiteralPath $root -File -Recurse -ErrorAction Stop
Write-Host "Files     : $($allFiles.Count)"

$relative = foreach ($file in $allFiles) {
    $file.FullName.Substring($root.Length).TrimStart([IO.Path]::DirectorySeparatorChar)
}

$caseCollisions = $relative |
    Group-Object { $_.ToLowerInvariant() } |
    Where-Object Count -gt 1

if ($caseCollisions) {
    Write-Warning 'Case-colliding paths detected:'
    foreach ($group in $caseCollisions) {
        $group.Group | ForEach-Object { Write-Warning "  $_" }
    }
} else {
    Write-Host 'Case-colliding paths: none detected'
}

$native = $allFiles | Where-Object { $_.Extension -in '.dll', '.exe', '.so', '.dylib' }
if ($native) {
    Write-Warning 'Native binaries detected. These may imply Windows/platform-specific features:'
    $native | ForEach-Object { Write-Warning "  $($_.FullName.Substring($root.Length).TrimStart('\'))" }
} else {
    Write-Host 'Native binaries: none detected'
}
