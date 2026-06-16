# ============================================================
# build-package.ps1 — Build both distribution formats
#
# Produces:
#   dist/
#     LangSwitcher-Install.exe          ← Windows GUI installer
#     com.ih4xz.langbutton.streamDeckPlugin  ← Official SD format
#
# Author : iH4xz — https://ih4xz.pro
# License: GPL-3.0
# ============================================================

$ErrorActionPreference = "Stop"
$ROOT     = Split-Path -Parent $MyInvocation.MyCommand.Path
$DIST     = Join-Path $ROOT "dist"
$PLUGIN   = Join-Path $ROOT "com.ih4xz.langbutton.sdPlugin"
$INSTALL  = Join-Path $ROOT "installer\install-selfcontained.ps1"

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Language Switcher - Build & Package" -ForegroundColor Cyan
Write-Host "  by iH4xz - https://ih4xz.pro" -ForegroundColor Gray
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# ---- Step 1: Build TypeScript ----
Write-Host "[1/4] Building TypeScript source..." -ForegroundColor Yellow
Push-Location $ROOT
& npm run build
if ($LASTEXITCODE -ne 0) { throw "npm build failed" }
Pop-Location
Write-Host "      [OK] plugin.js built" -ForegroundColor Green

# ---- Step 2: Create dist folder ----
if (-not (Test-Path $DIST)) { New-Item -ItemType Directory $DIST | Out-Null }

# ---- Step 3: Create .streamDeckPlugin (official ZIP format) ----
Write-Host ""
Write-Host "[2/4] Packaging .streamDeckPlugin..." -ForegroundColor Yellow

$sdpOut = Join-Path $DIST "com.ih4xz.langbutton.streamDeckPlugin"
if (Test-Path $sdpOut) { Remove-Item $sdpOut -Force }

Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
$zip = [System.IO.Compression.ZipFile]::Open($sdpOut, [System.IO.Compression.ZipArchiveMode]::Create)
$parent = Split-Path (Resolve-Path $PLUGIN).Path -Parent
Get-ChildItem $PLUGIN -Recurse -File | ForEach-Object {
    $entryName = $_.FullName.Substring($parent.Length + 1).Replace("\", "/")
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $entryName) | Out-Null
}
$zip.Dispose()

Write-Host "      [OK] $sdpOut packaged with proper path separators" -ForegroundColor Green

# ---- Step 3b: Update Base64 Payload in install-selfcontained.ps1 ----
Write-Host "      Updating Base64 payload in installer..." -ForegroundColor Gray
$bytes = [System.IO.File]::ReadAllBytes($sdpOut)
$b64 = [System.Convert]::ToBase64String($bytes)
$content = [System.IO.File]::ReadAllText($INSTALL)
$pattern = '(?m)^\$PLUGIN_B64\s*=\s*' + "'.*'"
$replacement = '$PLUGIN_B64 = ' + "'$b64'"
$newContent = [System.Text.RegularExpressions.Regex]::Replace($content, $pattern, $replacement)
[System.IO.File]::WriteAllText($INSTALL, $newContent)
Write-Host "      [OK] Base64 payload updated in $INSTALL" -ForegroundColor Green

# ---- Step 4: Compile EXE installer with ps2exe ----
Write-Host ""
Write-Host "[3/4] Compiling Windows EXE installer..." -ForegroundColor Yellow

$exeOut   = Join-Path $DIST "LangSwitcher-Install.exe"
$ps2exePs = Join-Path $ROOT "installer\ps2exe.ps1"

# Download ps2exe.ps1 if not present
if (-not (Test-Path $ps2exePs)) {
    Write-Host "      Downloading ps2exe..." -ForegroundColor Gray
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/MScholtes/PS2EXE/master/Module/ps2exe.ps1" `
        -OutFile $ps2exePs -UseBasicParsing
}

# Dot-source ps2exe and compile
. $ps2exePs
Invoke-ps2exe `
    -InputFile   $INSTALL `
    -OutputFile  $exeOut `
    -Title       "Language Switcher Installer" `
    -Description "Installs the Language Switcher Stream Deck plugin by iH4xz" `
    -Company     "iH4xz" `
    -Product     "Language Switcher for Stream Deck" `
    -Version     "1.0.0.0" `
    -Copyright   "GPL-3.0 - iH4xz 2026 - ih4xz.pro" `
    -noConsole

if (Test-Path $exeOut) {
    Write-Host "      [OK] $exeOut" -ForegroundColor Green
} else {
    Write-Host "      [ERROR] EXE compilation failed" -ForegroundColor Red
}

# ---- Step 5: Summary ----
Write-Host ""
Write-Host "[4/4] Done! Distribution files:" -ForegroundColor Yellow
Get-ChildItem $DIST | ForEach-Object {
    $size = "{0:N0} KB" -f ($_.Length / 1KB)
    Write-Host "      * $($_.Name)  ($size)" -ForegroundColor White
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Distribution ready in: $DIST" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
