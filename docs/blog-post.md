---
title: "Language Switcher for Stream Deck"
slug: "lang-switcher-btn"
date: "2026-06-16"
author: "iH4xz"
tags: ["stream-deck", "windows", "arabic", "keyboard", "open-source", "tool"]
description: "A cute dark-mode Stream Deck plugin to display and toggle your keyboard input language (EN/AR) in real-time on Windows 11."
cover: "/projects/lang-switcher-btn/cover.png"
github: "https://github.com/iH4xz/lang-switcher-btn"
license: "GPL-3.0"
---

# 🌐 Language Switcher Button for Stream Deck

If you work in both Arabic and English daily — and who in our region doesn't — you've felt that friction: switching the keyboard language constantly, losing track of which mode you're in mid-sentence, reaching for the wrong shortcut. I built this to solve that small but very real annoyance.

**Language Switcher** is a Stream Deck plugin for Windows 11 that shows your current keyboard language right on a physical button and lets you toggle it instantly with one press.

---

## The Problem

Windows 11 is great at multilingual work — but it gives you zero visual feedback about your current input language *unless* you glance down at the taskbar. When you're deep in a workflow, that context switch is distracting.

The Stream Deck sits right there on your desk. Why not use it as a persistent, glanceable indicator?

---

## What It Does

- **Live indicator** — the button dynamically renders the current input language: **EN** in glowing cyan or **ع** in glowing pink. No guessing.
- **One-tap toggle** — press the button to switch. It simulates your configured `Alt+Shift` shortcut so it works in every app.
- **Auto-updates** — switch via the taskbar or `Alt+Shift` manually, and the button updates within ~1.5 seconds.
- **Zero native dependencies** — no C++ build tools, no native modules. Just PowerShell talking to the Win32 API, bundled cleanly with the plugin.

---

## The Design

I wanted the button icons to feel *premium*, not like a stock icon. The design uses:

- **Dark navy gradient** background (`#0a0a14 → #1a1a2e`) so it looks sharp on the Stream Deck's LCD
- **Glassmorphic card** — a subtle frosted panel for depth
- **Glow effects** via SVG filters — the text literally glows in its accent color
- **Cyan `#00d4ff`** for English — clean, technical, focused
- **Pink `#ff6bcb`** for Arabic — warm, expressive, distinctive
- Small language label (`English` / `العربية`) beneath the main glyph for extra clarity

The icons are generated entirely in code as SVG — no static image files needed. This means they're crisp at any DPI and trivially customizable.

---

## How It Works Under the Hood

### Language Detection

The plugin calls into the Windows `user32.dll` via a small C# snippet embedded in PowerShell (P/Invoke):

```csharp
GetForegroundWindow()         // → HWND of active app
GetWindowThreadProcessId()    // → thread ID that owns the window
GetKeyboardLayout(threadId)   // → HKL handle containing LANGID
```

The low 16 bits of the HKL are the Language ID (`0x0409` = English US, `0x0401` = Arabic Saudi Arabia, and so on). Arabic covers all regional variants by checking the primary language byte `0x01`.

### Language Switching

Simulating `Alt+Shift` via `keybd_event()` is the most reliable cross-application approach. `ActivateKeyboardLayout()` would only affect the calling thread — not whatever app the user is focused on.

### Button Rendering

Every poll cycle, the plugin generates an SVG string and pushes it to the Stream Deck via `setImage()` as a data URI:

```js
action.setImage(`data:image/svg+xml,${encodeURIComponent(svg)}`);
```

SVGs are ideal here: vector-perfect, dynamic, and the Stream Deck SDK handles the encoding gracefully.

### Architecture

```
Stream Deck Software
    ↕ WebSocket
plugin.js (Node.js 20, ESM)
    ↕ setInterval 1.5s
    ↕ child_process.execFile
PowerShell scripts
    ↕ P/Invoke
Windows user32.dll (Win32 API)
```

No native addon compilation. No `ffi-napi`. No build tools beyond `npm install`.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Plugin runtime | Node.js 20 (Stream Deck bundled) |
| SDK | `@elgato/streamdeck` v1.1 |
| Language | TypeScript → bundled ESM via Rollup |
| Windows API | PowerShell + C# P/Invoke (no native modules) |
| Button graphics | Dynamic SVG via `setImage()` |
| License | GNU GPL v3.0 |

---

## Installation

The quickest way:

1. Download the `.streamDeckPlugin` file from [GitHub Releases](https://github.com/iH4xz/lang-switcher-btn/releases)
2. Double-click to install
3. Drag "Language Switch" onto a button

Full install guide in [English](https://github.com/iH4xz/lang-switcher-btn/blob/main/docs/INSTALL-EN.md) and [العربية](https://github.com/iH4xz/lang-switcher-btn/blob/main/docs/INSTALL-AR.md).

---

## Open Source

The full source is on GitHub at [`iH4xz/lang-switcher-btn`](https://github.com/iH4xz/lang-switcher-btn) under the **GPL-3.0** license. Contributions, forks, and issue reports are welcome.

If you're building your own Stream Deck plugin and want to interact with Win32 APIs without native module pain — the PowerShell P/Invoke pattern in this project is worth studying. It's clean, zero-build, and actually reliable.

---

*— iH4xz*
