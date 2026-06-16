/**
 * SVG Renderer — generates cute dark-mode button icons
 * by iH4xz — https://ih4xz.pro/projects/lang-switcher-btn/
 * License: GPL-3.0
 */

import { LANGUAGE_MAP, type LanguageCode } from "../types";

/**
 * Generates a 144×144 SVG string for the Stream Deck button.
 * 
 * Design:
 * - Dark gradient background (#0f0f1a → #1a1a2e)
 * - Glassmorphic rounded card
 * - Large bright language text with glow effect
 * - Small label at bottom
 * - Animated-looking accent dot
 */
export function renderButtonSVG(langCode: LanguageCode): string {
	const lang = LANGUAGE_MAP[langCode];
	const { shortLabel, label, accentColor, glowColor } = lang;

	// Arabic letter needs different font size & y-position since it's a single large glyph
	const isArabic = langCode === "ar";
	const mainFontSize = isArabic ? "68" : "56";
	const mainY = isArabic ? "88" : "84";
	const fontFamily = isArabic
		? "'Segoe UI', 'Arial', sans-serif"
		: "'Segoe UI', 'Inter', 'Arial', sans-serif";

	const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="144" height="144" viewBox="0 0 144 144">
  <defs>
    <!-- Background gradient -->
    <radialGradient id="bg" cx="50%" cy="40%" r="70%">
      <stop offset="0%" stop-color="#1e1e3a"/>
      <stop offset="100%" stop-color="#0a0a14"/>
    </radialGradient>

    <!-- Card gradient -->
    <linearGradient id="card" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#ffffff10"/>
      <stop offset="100%" stop-color="#ffffff05"/>
    </linearGradient>

    <!-- Glow filter for the main text -->
    <filter id="glow" x="-50%" y="-50%" width="200%" height="200%">
      <feGaussianBlur stdDeviation="8" result="blur"/>
      <feMerge>
        <feMergeNode in="blur"/>
        <feMergeNode in="blur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <!-- Subtle outer glow for the card -->
    <filter id="cardGlow" x="-10%" y="-10%" width="120%" height="120%">
      <feGaussianBlur stdDeviation="4" result="blur"/>
      <feMerge>
        <feMergeNode in="blur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <!-- Dot pulse glow -->
    <filter id="dotGlow" x="-100%" y="-100%" width="300%" height="300%">
      <feGaussianBlur stdDeviation="3"/>
    </filter>
  </defs>

  <!-- Background -->
  <rect width="144" height="144" rx="16" fill="url(#bg)"/>

  <!-- Subtle border ring -->
  <rect x="4" y="4" width="136" height="136" rx="14" 
        fill="none" stroke="${accentColor}" stroke-opacity="0.15" stroke-width="1"/>

  <!-- Glassmorphic card -->
  <rect x="16" y="14" width="112" height="96" rx="18" 
        fill="url(#card)" stroke="${accentColor}" stroke-opacity="0.2" stroke-width="0.8"
        filter="url(#cardGlow)"/>

  <!-- Main language text with glow -->
  <text x="72" y="${mainY}" 
        font-family="${fontFamily}" font-size="${mainFontSize}" font-weight="700"
        fill="${accentColor}" text-anchor="middle" 
        filter="url(#glow)">${shortLabel}</text>

  <!-- Bottom label -->
  <text x="72" y="130" 
        font-family="'Segoe UI', sans-serif" font-size="13" font-weight="400"
        fill="#ffffff" fill-opacity="0.6" text-anchor="middle">${label}</text>

  <!-- Active indicator dot -->
  <circle cx="72" cy="140" r="2.5" fill="${accentColor}" opacity="0.9"/>
  <circle cx="72" cy="140" r="5" fill="${accentColor}" filter="url(#dotGlow)" opacity="0.4"/>
</svg>`;

	return svg;
}

/**
 * Returns the SVG as a data URI suitable for setImage()
 */
export function renderButtonDataURI(langCode: LanguageCode): string {
	const svg = renderButtonSVG(langCode);
	return `data:image/svg+xml,${encodeURIComponent(svg)}`;
}
