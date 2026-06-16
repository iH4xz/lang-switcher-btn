/**
 * Language Detector — wraps PowerShell scripts for Win32 API calls
 * by iH4xz — https://ih4xz.pro/projects/lang-switcher-btn/
 * License: GPL-3.0
 */

import { execFile } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";
import type { LanguageCode } from "../types";

// Resolve the scripts directory relative to the compiled plugin.js location
// plugin.js lives in com.ih4xz.langbutton.sdPlugin/bin/
// scripts live in  com.ih4xz.langbutton.sdPlugin/scripts/
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SCRIPTS_DIR = path.resolve(__dirname, "..", "scripts");
const GET_LANG_SCRIPT = path.join(SCRIPTS_DIR, "get-language.ps1");
const SWITCH_LANG_SCRIPT = path.join(SCRIPTS_DIR, "switch-language.ps1");

const PS_ARGS = [
	"-NoProfile",
	"-NonInteractive",
	"-WindowStyle", "Hidden",
	"-ExecutionPolicy", "Bypass",
	"-File",
];

/**
 * Runs a PowerShell script and returns trimmed stdout
 */
function runPowerShell(scriptPath: string): Promise<string> {
	return new Promise((resolve, reject) => {
		execFile(
			"powershell.exe",
			[...PS_ARGS, scriptPath],
			{ timeout: 5000, windowsHide: true },
			(error, stdout, stderr) => {
				if (error) {
					reject(new Error(`PowerShell error: ${stderr || error.message}`));
				} else {
					resolve(stdout.trim());
				}
			}
		);
	});
}

/**
 * Detects the current keyboard input language of the foreground window
 */
export async function detectLanguage(): Promise<LanguageCode> {
	try {
		const result = await runPowerShell(GET_LANG_SCRIPT);
		if (result === "en" || result === "ar") {
			return result;
		}
		return "unknown";
	} catch (err) {
		console.error("[LangSwitcher] Detection error:", err);
		return "unknown";
	}
}

/**
 * Toggles the keyboard input language by simulating Alt+Shift
 */
export async function switchLanguage(): Promise<boolean> {
	try {
		const result = await runPowerShell(SWITCH_LANG_SCRIPT);
		return result === "ok";
	} catch (err) {
		console.error("[LangSwitcher] Switch error:", err);
		return false;
	}
}
