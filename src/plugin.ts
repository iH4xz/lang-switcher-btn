/**
 * Language Switcher for Stream Deck — Plugin Entry Point
 * by iH4xz — https://ih4xz.pro/projects/lang-switcher-btn/
 * 
 * Display and switch keyboard input language (EN/AR) with a single button press.
 * Cute dark-mode icons with bright glowing indicators.
 * 
 * License: GPL-3.0
 * Source:  https://github.com/iH4xz/lang-switcher-btn
 */

import streamDeck from "@elgato/streamdeck";
import { LangSwitchAction } from "./actions/lang-switch";

// Register the action
streamDeck.actions.registerAction(new LangSwitchAction());

// Connect to the Stream Deck
streamDeck.connect();
