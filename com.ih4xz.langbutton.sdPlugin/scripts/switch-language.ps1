# PowerShell script to toggle keyboard input language using Alt+Shift
# This simulates the Windows keyboard shortcut to cycle input languages

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class KeySender {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    public const byte VK_MENU = 0x12;    // Alt key
    public const byte VK_SHIFT = 0x10;   // Shift key
    public const uint KEYEVENTF_KEYDOWN = 0x0000;
    public const uint KEYEVENTF_KEYUP = 0x0002;

    public static void SendAltShift() {
        // Press Alt
        keybd_event(VK_MENU, 0, KEYEVENTF_KEYDOWN, UIntPtr.Zero);
        // Press Shift
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYDOWN, UIntPtr.Zero);
        // Release Shift
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
        // Release Alt
        keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, UIntPtr.Zero);
    }
}
"@ -ErrorAction SilentlyContinue

try {
    [KeySender]::SendAltShift()
    Write-Output "ok"
}
catch {
    Write-Output "error"
}
