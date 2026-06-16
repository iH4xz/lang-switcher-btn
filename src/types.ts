/**
 * Language Switcher for Stream Deck
 * by iH4xz — https://ih4xz.pro/projects/lang-switcher-btn/
 * 
 * Displays the current keyboard input language (EN/AR) on the button
 * and toggles between languages on press.
 * 
 * License: GPL-3.0
 * Source:  https://github.com/iH4xz/lang-switcher-btn
 */

export type LanguageCode = "en" | "ar" | "unknown";

export interface LanguageInfo {
	code: LanguageCode;
	label: string;
	shortLabel: string;
	accentColor: string;
	glowColor: string;
}

export const LANGUAGE_MAP: Record<LanguageCode, LanguageInfo> = {
	en: {
		code: "en",
		label: "English",
		shortLabel: "EN",
		accentColor: "#00d4ff",
		glowColor: "#00d4ff55",
	},
	ar: {
		code: "ar",
		label: "العربية",
		shortLabel: "ع",
		accentColor: "#ff6bcb",
		glowColor: "#ff6bcb55",
	},
	unknown: {
		code: "unknown",
		label: "??",
		shortLabel: "?",
		accentColor: "#888888",
		glowColor: "#88888855",
	},
};
