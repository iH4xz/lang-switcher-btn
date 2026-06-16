/**
 * Language Switch Action — main Stream Deck action
 * by iH4xz — https://ih4xz.pro/projects/lang-switcher-btn/
 * License: GPL-3.0
 */

import {
	action,
	SingletonAction,
	type KeyDownEvent,
	type WillAppearEvent,
	type WillDisappearEvent,
} from "@elgato/streamdeck";

import { detectLanguage, switchLanguage } from "../helpers/language-detector";
import { renderButtonDataURI } from "../helpers/svg-renderer";
import type { LanguageCode } from "../types";

/** Polling interval in milliseconds */
const POLL_INTERVAL_MS = 1500;

/** Delay after switching before re-polling (let Windows settle) */
const SWITCH_SETTLE_MS = 350;

@action({ UUID: "com.ih4xz.langbutton.switch" })
export class LangSwitchAction extends SingletonAction {

	/**
	 * Map of action instance IDs → their polling timers.
	 * Supports multiple buttons on different Stream Deck pages.
	 */
	private timers: Map<string, ReturnType<typeof setInterval>> = new Map();

	/**
	 * Track the last known language per action to avoid redundant setImage calls.
	 */
	private lastLang: Map<string, LanguageCode> = new Map();

	/**
	 * Called when the action appears on the Stream Deck (page visible, etc.)
	 * Start polling the keyboard language.
	 */
	override async onWillAppear(ev: WillAppearEvent): Promise<void> {
		const actionId = ev.action.id;

		// Clear any existing timer for this action
		this.clearTimer(actionId);

		// Do an immediate update
		await this.updateButton(ev);

		// Start polling
		const timer = setInterval(async () => {
			await this.updateButton(ev);
		}, POLL_INTERVAL_MS);

		this.timers.set(actionId, timer);
	}

	/**
	 * Called when the action disappears (page switch, action removed, etc.)
	 * Clean up the polling timer.
	 */
	override onWillDisappear(ev: WillDisappearEvent): void {
		this.clearTimer(ev.action.id);
		this.lastLang.delete(ev.action.id);
	}

	/**
	 * Called when the button is pressed.
	 * Toggle the language and update the button.
	 */
	override async onKeyDown(ev: KeyDownEvent): Promise<void> {
		// Switch the language
		await switchLanguage();

		// Wait a moment for Windows to process the change
		await new Promise((resolve) => setTimeout(resolve, SWITCH_SETTLE_MS));

		// Force-clear last known lang so it always updates the image
		this.lastLang.delete(ev.action.id);

		// Re-poll and update the button
		await this.updateButton(ev);
	}

	/**
	 * Polls the current language and updates the button image if changed.
	 */
	private async updateButton(ev: WillAppearEvent | KeyDownEvent): Promise<void> {
		try {
			const currentLang = await detectLanguage();
			const actionId = ev.action.id;

			// Only update the image if the language actually changed
			if (this.lastLang.get(actionId) !== currentLang) {
				const dataUri = renderButtonDataURI(currentLang);
				await ev.action.setImage(dataUri);
				this.lastLang.set(actionId, currentLang);
			}
		} catch (err) {
			console.error("[LangSwitcher] Update error:", err);
		}
	}

	/**
	 * Clears the polling timer for a specific action instance.
	 */
	private clearTimer(actionId: string): void {
		const existing = this.timers.get(actionId);
		if (existing) {
			clearInterval(existing);
			this.timers.delete(actionId);
		}
	}
}
