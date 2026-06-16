# PowerShell script to detect the current keyboard input language
# Uses P/Invoke to call Win32 APIs for accurate per-window detection
# Returns: "en", "ar", or the hex LANGID for unknown languages

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class KeyboardHelper {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, IntPtr lpdwProcessId);

    [DllImport("user32.dll")]
    public static extern IntPtr GetKeyboardLayout(uint idThread);
}
"@ -ErrorAction SilentlyContinue

try {
    $hwnd = [KeyboardHelper]::GetForegroundWindow()
    $threadId = [KeyboardHelper]::GetWindowThreadProcessId($hwnd, [IntPtr]::Zero)
    $hkl = [KeyboardHelper]::GetKeyboardLayout($threadId)

    # Extract the low word (Language ID) from the HKL handle
    $langId = [int]$hkl -band 0xFFFF

    # Map known language IDs
    switch ($langId) {
        0x0409 { Write-Output "en" }  # English (US)
        0x0809 { Write-Output "en" }  # English (UK)
        0x0c09 { Write-Output "en" }  # English (Australia)
        0x1009 { Write-Output "en" }  # English (Canada)
        0x0401 { Write-Output "ar" }  # Arabic (Saudi Arabia)
        0x0801 { Write-Output "ar" }  # Arabic (Iraq)
        0x0c01 { Write-Output "ar" }  # Arabic (Egypt)
        0x1001 { Write-Output "ar" }  # Arabic (Libya)
        0x1401 { Write-Output "ar" }  # Arabic (Algeria)
        0x1801 { Write-Output "ar" }  # Arabic (Morocco)
        0x1c01 { Write-Output "ar" }  # Arabic (Tunisia)
        0x2001 { Write-Output "ar" }  # Arabic (Oman)
        0x2401 { Write-Output "ar" }  # Arabic (Yemen)
        0x2801 { Write-Output "ar" }  # Arabic (Syria)
        0x2c01 { Write-Output "ar" }  # Arabic (Jordan)
        0x3001 { Write-Output "ar" }  # Arabic (Lebanon)
        0x3401 { Write-Output "ar" }  # Arabic (Kuwait)
        0x3801 { Write-Output "ar" }  # Arabic (UAE)
        0x3c01 { Write-Output "ar" }  # Arabic (Bahrain)
        0x4001 { Write-Output "ar" }  # Arabic (Qatar)
        default {
            # Check if it's any Arabic variant (primary language ID 0x01)
            if (($langId -band 0xFF) -eq 0x01) {
                Write-Output "ar"
            }
            # Check if it's any English variant (primary language ID 0x09)
            elseif (($langId -band 0xFF) -eq 0x09) {
                Write-Output "en"
            }
            else {
                Write-Output "unknown"
            }
        }
    }
}
catch {
    Write-Output "unknown"
}
