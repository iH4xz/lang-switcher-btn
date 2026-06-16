# ============================================================
# Language Switcher for Stream Deck — Windows Installer
# Author : iH4xz — https://ih4xz.pro
# GitHub : https://github.com/iH4xz/lang-switcher-btn
# License: GPL-3.0
# ============================================================

#Requires -Version 5.1

# Embed the plugin files as base64 at compile-time (injected by build script)
# This script is compiled to EXE by ps2exe with -extract flag to include files

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---- Configuration ----
$PLUGIN_UUID     = "com.ih4xz.langbutton"
$PLUGIN_NAME     = "Language Switcher"
$PLUGIN_VERSION  = "1.0.0"
$PLUGIN_AUTHOR   = "iH4xz"
$PLUGIN_URL      = "https://ih4xz.pro/projects/lang-switcher-btn/"
$PLUGIN_FOLDER   = "$PLUGIN_UUID.sdPlugin"
$PLUGINS_DIR     = "$env:APPDATA\Elgato\StreamDeck\Plugins"
$DEST_PATH       = Join-Path $PLUGINS_DIR $PLUGIN_FOLDER

# Source folder — relative to where this script lives
$SCRIPT_DIR      = Split-Path -Parent $MyInvocation.MyCommand.Path
$SOURCE_PLUGIN   = Join-Path $SCRIPT_DIR "..\com.ih4xz.langbutton.sdPlugin"

# ---- Helpers ----
function Show-MessageBox($msg, $title, $icon = "Information", $buttons = "OK") {
    return [System.Windows.Forms.MessageBox]::Show(
        $msg, $title,
        [System.Windows.Forms.MessageBoxButtons]::$buttons,
        [System.Windows.Forms.MessageBoxIcon]::$icon
    )
}

function Test-StreamDeckInstalled {
    $sdPath = "${env:ProgramFiles}\Elgato\StreamDeck\StreamDeck.exe"
    $sdPath86 = "${env:ProgramFiles(x86)}\Elgato\StreamDeck\StreamDeck.exe"
    return (Test-Path $sdPath) -or (Test-Path $sdPath86)
}

function Get-StreamDeckProcess {
    return Get-Process -Name "StreamDeck" -ErrorAction SilentlyContinue
}

function Stop-StreamDeck {
    $proc = Get-StreamDeckProcess
    if ($proc) {
        $proc | Stop-Process -Force
        Start-Sleep -Milliseconds 1500
    }
}

function Start-StreamDeck {
    $sdExe = "${env:ProgramFiles}\Elgato\StreamDeck\StreamDeck.exe"
    if (-not (Test-Path $sdExe)) {
        $sdExe = "${env:ProgramFiles(x86)}\Elgato\StreamDeck\StreamDeck.exe"
    }
    if (Test-Path $sdExe) {
        Start-Process $sdExe
    }
}

# ---- Splash / Progress Form ----
function Show-InstallerForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "$PLUGIN_NAME Installer v$PLUGIN_VERSION"
    $form.Size = New-Object System.Drawing.Size(480, 320)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 26)
    $form.ForeColor = [System.Drawing.Color]::White

    # Title label
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Language Switcher"
    $lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
    $lblTitle.ForeColor = [System.Drawing.Color]::FromArgb(0, 212, 255)
    $lblTitle.Location = New-Object System.Drawing.Point(20, 24)
    $lblTitle.Size = New-Object System.Drawing.Size(440, 44)

    # Subtitle
    $lblSub = New-Object System.Windows.Forms.Label
    $lblSub.Text = "Stream Deck Plugin  •  EN / ع  •  by $PLUGIN_AUTHOR"
    $lblSub.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $lblSub.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 200)
    $lblSub.Location = New-Object System.Drawing.Point(20, 70)
    $lblSub.Size = New-Object System.Drawing.Size(440, 24)

    # Separator
    $sep = New-Object System.Windows.Forms.Label
    $sep.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 70)
    $sep.Location = New-Object System.Drawing.Point(20, 102)
    $sep.Size = New-Object System.Drawing.Size(440, 1)

    # Status label
    $script:lblStatus = New-Object System.Windows.Forms.Label
    $script:lblStatus.Text = "Ready to install."
    $script:lblStatus.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $script:lblStatus.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 240)
    $script:lblStatus.Location = New-Object System.Drawing.Point(20, 118)
    $script:lblStatus.Size = New-Object System.Drawing.Size(440, 60)

    # Progress bar
    $script:progress = New-Object System.Windows.Forms.ProgressBar
    $script:progress.Minimum = 0
    $script:progress.Maximum = 100
    $script:progress.Value = 0
    $script:progress.Style = "Continuous"
    $script:progress.Location = New-Object System.Drawing.Point(20, 186)
    $script:progress.Size = New-Object System.Drawing.Size(440, 16)

    # Install button
    $script:btnInstall = New-Object System.Windows.Forms.Button
    $script:btnInstall.Text = "Install"
    $script:btnInstall.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $script:btnInstall.BackColor = [System.Drawing.Color]::FromArgb(0, 140, 180)
    $script:btnInstall.ForeColor = [System.Drawing.Color]::White
    $script:btnInstall.FlatStyle = "Flat"
    $script:btnInstall.Location = New-Object System.Drawing.Point(20, 222)
    $script:btnInstall.Size = New-Object System.Drawing.Size(200, 44)
    $script:btnInstall.Cursor = [System.Windows.Forms.Cursors]::Hand

    # Cancel button
    $script:btnCancel = New-Object System.Windows.Forms.Button
    $script:btnCancel.Text = "Cancel"
    $script:btnCancel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $script:btnCancel.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 70)
    $script:btnCancel.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    $script:btnCancel.FlatStyle = "Flat"
    $script:btnCancel.Location = New-Object System.Drawing.Point(260, 222)
    $script:btnCancel.Size = New-Object System.Drawing.Size(200, 44)
    $script:btnCancel.Cursor = [System.Windows.Forms.Cursors]::Hand
    $script:btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    # Footer
    $lblFooter = New-Object System.Windows.Forms.Label
    $lblFooter.Text = "$PLUGIN_URL  |  GPL-3.0 Open Source"
    $lblFooter.Font = New-Object System.Drawing.Font("Segoe UI", 8)
    $lblFooter.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 130)
    $lblFooter.Location = New-Object System.Drawing.Point(20, 278)
    $lblFooter.Size = New-Object System.Drawing.Size(440, 18)

    # Wire up Install button
    $script:btnInstall.Add_Click({
        $script:btnInstall.Enabled = $false
        $script:btnCancel.Enabled = $false
        Start-Installation
    })

    $form.Controls.AddRange(@(
        $lblTitle, $lblSub, $sep,
        $script:lblStatus, $script:progress,
        $script:btnInstall, $script:btnCancel,
        $lblFooter
    ))
    $form.CancelButton = $script:btnCancel

    return $form
}

function Update-Status($msg, $pct) {
    $script:lblStatus.Text = $msg
    $script:progress.Value = [Math]::Min($pct, 100)
    [System.Windows.Forms.Application]::DoEvents()
}

function Start-Installation {
    try {
        Update-Status "Checking Stream Deck installation..." 10

        if (-not (Test-Path $PLUGINS_DIR)) {
            if (-not (Test-StreamDeckInstalled)) {
                Show-MessageBox "Stream Deck software is not installed.`n`nPlease install it from:`nhttps://www.elgato.com/downloads" `
                    "Stream Deck Not Found" "Error"
                $script:btnCancel.PerformClick()
                return
            }
            New-Item -ItemType Directory -Path $PLUGINS_DIR -Force | Out-Null
        }

        Update-Status "Stopping Stream Deck software..." 25
        $wasRunning = $null -ne (Get-StreamDeckProcess)
        if ($wasRunning) { Stop-StreamDeck }

        Update-Status "Removing old version (if any)..." 40
        if (Test-Path $DEST_PATH) {
            Remove-Item $DEST_PATH -Recurse -Force
        }

        Update-Status "Copying plugin files..." 60
        if (-not (Test-Path $SOURCE_PLUGIN)) {
            Show-MessageBox "Plugin source not found at:`n$SOURCE_PLUGIN`n`nPlease run this installer from the project folder." `
                "Files Not Found" "Error"
            $script:btnInstall.Enabled = $true
            $script:btnCancel.Enabled = $true
            return
        }
        Copy-Item $SOURCE_PLUGIN $DEST_PATH -Recurse -Force

        Update-Status "Verifying installation..." 80

        $manifestPath = Join-Path $DEST_PATH "manifest.json"
        if (-not (Test-Path $manifestPath)) {
            throw "Manifest file missing after copy — installation may be incomplete."
        }

        Update-Status "Restarting Stream Deck..." 90
        if ($wasRunning) { Start-StreamDeck }

        Update-Status "✅  Installation complete!" 100

        $script:btnInstall.Text = "Done ✓"
        $script:btnInstall.BackColor = [System.Drawing.Color]::FromArgb(0, 160, 80)
        $script:btnCancel.Text = "Close"
        $script:btnCancel.Enabled = $true

        Show-MessageBox "Language Switcher installed successfully!`n`nOpen Stream Deck, find 'Language Switcher' in the actions panel, and drag it to a button.`n`nEnjoy! — iH4xz" `
            "Installation Complete" "Information"

    } catch {
        Update-Status "❌  Error: $_" 0
        Show-MessageBox "Installation failed:`n`n$_`n`nPlease report this at:`nhttps://github.com/iH4xz/lang-switcher-btn/issues" `
            "Installation Error" "Error"
        $script:btnInstall.Enabled = $true
        $script:btnCancel.Enabled = $true
    }
}

# ---- Main Entry ----
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = Show-InstallerForm
$form.ShowDialog() | Out-Null
