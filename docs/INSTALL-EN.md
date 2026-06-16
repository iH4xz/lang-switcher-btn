# 🌐 Language Switcher — Installation Guide (English)

**Plugin:** Language Switcher for Stream Deck  
**Author:** iH4xz — [ih4xz.pro](https://ih4xz.pro)  
**Project Page:** [ih4xz.pro/projects/lang-switcher-btn](https://ih4xz.pro/projects/lang-switcher-btn/)  
**Source:** [github.com/iH4xz/lang-switcher-btn](https://github.com/iH4xz/lang-switcher-btn)  
**License:** GPL-3.0

---

## Requirements

| Item | Minimum Version |
|---|---|
| Stream Deck Software | 6.6 or later |
| Windows | 10 or 11 |
| Node.js | 20 (bundled by Stream Deck) |
| Stream Deck Device | Any model with Keypad buttons |

> **Language Shortcut:** This plugin uses **Alt + Shift** to toggle between languages — the same shortcut configured in your Windows 11 language settings.

---

## Option A — Install from Release (Easiest)

1. Go to the [Releases page](https://github.com/iH4xz/lang-switcher-btn/releases)
2. Download the latest `com.ih4xz.langbutton.streamDeckPlugin` file
3. **Double-click** the downloaded file
4. Stream Deck software will open and ask to confirm — click **Install**
5. The plugin appears in the Stream Deck action list under **"Language Switcher"**

---

## Option B — Install from Source (Developers)

### Step 1 — Clone the repository

```bash
git clone https://github.com/iH4xz/lang-switcher-btn.git
cd lang-switcher-btn
```

### Step 2 — Install dependencies

```bash
npm install
```

### Step 3 — Build the plugin

```bash
npm run build
```

This compiles the TypeScript source into `com.ih4xz.langbutton.sdPlugin/bin/plugin.js`.

### Step 4 — Copy the plugin folder

Copy the entire `com.ih4xz.langbutton.sdPlugin` folder to your Stream Deck plugins directory:

```
%APPDATA%\Elgato\StreamDeck\Plugins\
```

**Tip:** You can open this folder quickly by pressing `Win + R` and typing:
```
%APPDATA%\Elgato\StreamDeck\Plugins
```

### Step 5 — Restart Stream Deck

Close and reopen the Stream Deck software. The plugin will load automatically.

---

## How to Add the Button

1. Open the **Stream Deck** application
2. In the right panel, find **"Language Switcher"** under the plugin category
3. **Drag** the "Language Switch" action onto any button slot
4. The button will immediately show your current keyboard language (**EN** or **ع**)

---

## Using the Button

| Action | Result |
|---|---|
| **Look at button** | Shows current keyboard language (EN / ع) |
| **Press button** | Toggles to the other language |
| **Switch via taskbar** | Button updates automatically within ~2 seconds |

---

## Troubleshooting

### The button always shows "??"
- Make sure your Windows language bar is set up with both English and Arabic
- Go to: **Settings → Time & Language → Language & Region**
- Ensure both English and Arabic are added as input languages

### The language doesn't switch when I press the button
- Verify your Windows language toggle shortcut is set to **Alt + Shift**
- Go to: **Settings → Time & Language → Typing → Advanced keyboard settings → Input language hot keys**
- Make sure Alt+Shift is configured there

### The button doesn't appear in Stream Deck
- Make sure the `com.ih4xz.langbutton.sdPlugin` folder is inside `%APPDATA%\Elgato\StreamDeck\Plugins\`
- Restart the Stream Deck software
- Check the Stream Deck software version (needs 6.6+)

### PowerShell execution error
- Run PowerShell as Administrator and execute:
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```

---

## Uninstall

1. Open Stream Deck software
2. Go to **Preferences → Plugins**
3. Find **Language Switcher** and click the **×** button to remove

---

*Made with ❤️ by iH4xz — [ih4xz.pro](https://ih4xz.pro)*
