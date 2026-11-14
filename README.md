NovaUI — Fluid Edition

<div align="center">

A beautiful, animation-rich Roblox UI library with Jily-style spring physics, glass morphism, and staggered entrance animations.

https://img.shields.io/badge/version-1.0-blueviolet?style=for-the-badge
https://img.shields.io/badge/platform-Roblox-red?style=for-the-badge
https://img.shields.io/badge/language-Luau-00A2FF?style=for-the-badge
https://img.shields.io/badge/license-MIT-green?style=for-the-badge
https://img.shields.io/badge/status-stable-success?style=for-the-badge

Installation · Quick Start · API Reference · Examples · Themes

</div>

---

📖 Table of Contents

· Why NovaUI?
· Features
· Installation
· Quick Start
· API Reference
  · Window
  · Tabs
  · Elements
  · Notifications
  · Themes
  · Config System
· Complete Examples
· Animation System
· Customization
· Troubleshooting
· FAQ
· License

---

🌟 Why NovaUI?

NovaUI was built from the ground up to feel alive. Every interaction has weight, every transition has rhythm, and every element has personality. Unlike other libraries that feel static and cold, NovaUI uses spring physics and staggered animations to create a UI that breathes.

Feature NovaUI Others
Spring physics animations ✅ ❌
Staggered element entrance ✅ ❌
Sliding tab highlight pill ✅ ❌
Ripple click feedback ✅ ⚠️ Rare
Stacked notifications ✅ ⚠️ Simple
Glass morphism surfaces ✅ ⚠️ Flat
Floating action button ✅ ❌
Live theme switching ✅ ✅
Config save/load ✅ ✅
Zero dependencies ✅ ⚠️ Varies

---

✨ Features

<table>
<tr>
<td width="50%">

🎬 Motion

· Back-ease "pop" on window open/close
· Spring bounce on toggles and pill slides
· Staggered slide-in for every element
· Ripple circles expanding from clicks
· Hover grow on buttons and close icon
· Floating bob on the FAB
· Rotating halo around the logo

</td>
<td width="50%">

🎨 Visual

· Glass morphism with frosted surfaces
· Soft shadows for depth
· Live accent pill that slides between tabs
· 6 hand-tuned themes (2 light, 4 dark)
· Configurable radius per theme
· UIStroke accents on active elements
· Emoji-free icons — pure glyphs

</td>
</tr>
<tr>
<td>

🧩 Components

· Window with drag & hotkey
· Tabs with morphing highlight
· Sections & labels
· Buttons with ripple
· Toggles with spring knob
· Sliders with live value
· Dropdowns with pop expand
· Textboxes with placeholder
· Keybind pickers

</td>
<td>

⚙️ System

· Flags auto-sync to Nova.Flags
· Config save/load via JSON
· Stacked notifications with reflow
· Per-window hotkey toggle
· Global theme switch (live)
· Zero external dependencies
· Single-file library

</td>
</tr>
</table>

---

📦 Installation

⚡ Method 1 — Loadstring (Recommended)

```lua
local Nova = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/NovaUI.lua"))()
```

📁 Method 2 — Local file

1. Download NovaUI.lua from this repository
2. Paste it into your executor's script editor
3. Append your code after return Nova

🔗 Method 3 — Custom host

Host NovaUI.lua on any raw URL (GitHub raw, Pastebin raw, your own server) and load it:

```lua
local Nova = loadstring(game:HttpGet("https://your-host.com/NovaUI.lua"))()
```

⚠️ Requirements: An executor that supports loadstring, game:HttpGet, and (optional) writefile / readfile / isfile for config persistence.

---

🚀 Quick Start

Copy, paste, run. That's it.

```lua
local Nova = loadstring(game:HttpGet("YOUR_URL"))()

-- Create the window
local win = Nova.new({
    Title     = "My Hub",
    Subtitle  = "v1.0 · fluid",
    Icon      = "✦",
    Size      = UDim2.new(0, 420, 0, 340),
    ToggleKey = Enum.KeyCode.RightShift,
})

-- Add a tab
local main = win:Tab("Main")

-- Add elements
win:Section(main, "Combat")
win:Toggle(main, "Auto Aim", false, "aim", function(state)
    print("Auto Aim:", state)
end)

win:Slider(main, "FOV", 10, 360, 90, "fov", function(value)
    print("FOV:", value)
end)

win:Button(main, "Execute", function()
    Nova:Notify({ title = "Done", text = "Executed!", color = Nova.Theme.success })
end)
```

That's a complete working UI. Now let's go deeper.

---

📖 API Reference

Window

Nova.new(config)

Creates a new window instance and returns it.

Parameter Type Default Description
Title string "Nova" Window title text
Subtitle string "v1.0 · fluid" Subtitle under title
Icon string "✦" Emoji/glyph for logo
Size UDim2 UDim2.new(0, 420, 0, 340) Window size
ToggleKey Enum.KeyCode RightShift Hotkey to show/hide

```lua
local win = Nova.new({
    Title     = "My Hub",
    Subtitle  = "fluid edition",
    Icon      = "⭐",
    Size      = UDim2.new(0, 500, 0, 400),
    ToggleKey = Enum.KeyCode.F1,
})
```

Returns: Window object with methods below.

---

win:Show()

Animates the window open with a spring pop. Idempotent — safe to call multiple times.

```lua
win:Show()
```

---

win:Hide()

Animates the window closed by shrinking to zero size.

```lua
win:Hide()
```

---

win:Toggle()

Shows the window if hidden, hides it if shown.

```lua
win:Toggle()
```

---

Tabs

win:Tab(name)

Creates a new tab button in the tab rail and a content page. First tab is auto-selected.

```lua
local main     = win:Tab("Main")
local settings = win:Tab("Settings")
local about    = win:Tab("About")
```

Returns: { Name, Button, Page }

Field Type Description
Name string Tab display name
Button TextButton The clickable tab button
Page Frame The content container

---

win:Pick(tab)

Programmatically switches to a specific tab with animation.

```lua
win:Pick(settings)
```

---

Elements

All element functions take the tab object as first argument.

win:Section(tab, text)

Visual divider with a ✦ prefix and uppercase text.

```lua
win:Section(main, "Combat")
win:Section(main, "Visuals")
win:Section(main, "Misc")
```

---

win:Label(tab, text)

Simple informational text label with subtle background.

```lua
win:Label(main, "Press RightShift to toggle the UI")
```

---

win:Button(tab, label, callback, color?)

Animated button with ripple click effect and hover grow.

Parameter Type Description
label string Button text
callback function Called on click
color Color3? Optional override (defaults to accent)

```lua
-- Default accent color
win:Button(main, "Execute", function()
    print("clicked!")
end)

-- Custom danger color
win:Button(main, "Self Destruct", function()
    print("boom")
end, Nova.Theme.danger)

-- Custom success color
win:Button(main, "Confirm", function()
    print("ok")
end, Nova.Theme.success)
```

Returns: { SetEnabled(bool) }

---

win:Toggle(tab, label, default, flag, callback)

On/off switch with spring-animated knob and glowing track.

Parameter Type Description
label string Display label
default boolean Initial state
flag string Config key (auto-synced to Nova.Flags)
callback function(state) Called on every change

```lua
win:Toggle(main, "Auto Aim", false, "aim", function(state)
    print("Auto Aim:", state)
end)
```

Returns: { flag, Set(bool), Get() }

---

win:Slider(tab, label, min, max, default, flag, callback)

Draggable slider with live value display and smooth fill animation.

Parameter Type Description
min number Minimum value
max number Maximum value
default number Initial value (clamped)
flag string Config key
callback function(value) Called on every drag tick

```lua
win:Slider(main, "Walk Speed", 16, 200, 16, "walkspeed", function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

Returns: { flag, Set(number), Get() }

---

win:Dropdown(tab, label, options, default, flag, callback)

Expandable selection menu with pop animation on open/close.

Parameter Type Description
options table Array of string options
default string Pre-selected option
flag string Config key
callback function(choice) Called on selection

```lua
win:Dropdown(main, "Method", {"Fast", "Safe", "Bypass"}, "Fast", "method", function(choice)
    print("Selected:", choice)
end)
```

Returns: { flag, value, Set(string), Get() }

---

win:Textbox(tab, label, placeholder, default, flag, callback)

Text input field with placeholder support.

Parameter Type Description
placeholder string Ghost text when empty
default string Initial text
flag string Config key
callback function(text) Called on focus lost

```lua
win:Textbox(main, "Webhook URL", "https://discord.com/...", "", "webhook", function(text)
    print("Entered:", text)
end)
```

Returns: { flag, Set(string), Get() }

---

win:Keybind(tab, label, default, flag, callback)

Interactive keybind picker. Click the button, then press any key to bind it.

```lua
win:Keybind(main, "Toggle UI", Enum.KeyCode.RightShift, "hotkey", function()
    print("keybind fired!")
end)
```

Returns: { flag, key, Set(KeyCode), Get() }

---

Notifications

Nova:Notify(config)

Displays a stacked notification in the top-right. Multiple notifications reflow automatically.

Parameter Type Default Description
title string "Notification" Bold header text
text string "" Body content
color Color3 Theme accent Accent color for bar/title
duration number 4 Seconds visible

```lua
Nova:Notify({
    title = "Success",
    text = "Script loaded successfully",
    color = Nova.Theme.success,
    duration = 3,
})
```

Each notification has:

· Slide-in from right with spring
· Colored accent bar on the left
· Soft drop shadow
· Auto-dismiss with fade-out
· Automatic stack reflow when others expire

---

Themes

Nova:SetTheme(name)

Live-switch the global palette. All open windows update instantly.

Theme Vibe
Aurora Purple/violet dark (default)
Sakura Soft pink light
Midnight Deep blue dark
Neon Cyan/magenta cyberpunk
Ember Warm orange/red fire
Frost Clean light blue

```lua
Nova:SetTheme("Neon")
Nova:SetTheme("Sakura")
Nova:SetTheme("Aurora")  -- back to default
```

Returns: true on success, false if theme name is invalid.

---

Config System

Nova:Save(file?)

Saves all flagged element values to a JSON file.

```lua
Nova:Save()              -- Saves to "NovaConfig.json"
Nova:Save("mycfg.json")  -- Custom filename
```

---

Nova:Load(file?)

Loads values from JSON and updates all registered elements.

```lua
Nova:Load()
Nova:Load("mycfg.json")
```

Flags are automatically populated in Nova.Flags[flag] whenever an element changes.

```lua
-- Manual flag access
print(Nova.Flags.aim)        -- true/false
print(Nova.Flags.fov)        -- number
print(Nova.Flags.method)     -- string
```

⚠️ Config save requires writefile, readfile, and isfile — standard in most executors. If unsupported, the calls silently no-op.

---

💡 Examples

🎮 Complete Combat Script

```lua
local Nova = loadstring(game:HttpGet("YOUR_URL"))()

local win = Nova.new({
    Title = "Combat Hub",
    Subtitle = "combat · v1.0",
    Icon = "⚔",
})

-- ═══════════ Combat Tab ═══════════
local combat = win:Tab("Combat")

win:Section(combat, "Aim Assist")
win:Toggle(combat, "Enabled", false, "aim_enabled", function(v)
    print("Aim Assist:", v)
end)
win:Slider(combat, "FOV", 10, 360, 90, "aim_fov", function(v)
    print("FOV:", v)
end)
win:Slider(combat, "Smoothing", 0, 1, 0.3, "aim_smooth")
win:Dropdown(combat, "Hitbox", {"Head", "Body", "Nearest"}, "Head", "hitbox")

win:Section(combat, "Triggerbot")
win:Toggle(combat, "Enabled", false, "trigger_enabled")
win:Slider(combat, "Delay", 0, 500, 100, "trigger_delay")

-- ═══════════ Visuals Tab ═══════════
local visuals = win:Tab("Visuals")

win:Section(visuals, "ESP")
win:Toggle(visuals, "Player ESP", false, "esp_players")
win:Toggle(visuals, "Box ESP", false, "esp_boxes")
win:Toggle(visuals, "Tracer Lines", false, "esp_tracers")
win:Slider(visuals, "Max Distance", 100, 5000, 1000, "esp_distance")
win:Keybind(visuals, "Toggle ESP", Enum.KeyCode.F, "esp_hotkey")

-- ═══════════ Config Tab ═══════════
local config = win:Tab("Config")

win:Section(config, "Persistence")
win:Button(config, "💾 Save Config", function()
    Nova:Save()
end)
win:Button(config, "📂 Load Config", function()
    Nova:Load()
end)

win:Section(config, "Themes")
win:Button(config, "🎨 Aurora",  function() Nova:SetTheme("Aurora")  end)
win:Button(config, "🌸 Sakura",  function() Nova:SetTheme("Sakura")  end)
win:Button(config, "🌙 Midnight",function() Nova:SetTheme("Midnight")end)
win:Button(config, "⚡ Neon",    function() Nova:SetTheme("Neon")    end)
win:Button(config, "🔥 Ember",   function() Nova:SetTheme("Ember")   end)
win:Button(config, "❄️ Frost",   function() Nova:SetTheme("Frost")   end)

-- ═══════════ Welcome ═══════════
Nova:Notify({
    title = "Loaded",
    text = "Combat Hub is ready",
    color = Nova.Theme.success,
})
```

---

🎨 Theme Switcher Mini-Example

```lua
local Nova = loadstring(game:HttpGet("YOUR_URL"))()
local win = Nova.new({ Title = "Theme Demo" })
local tab = win:Tab("Themes")

for _, name in ipairs({"Aurora", "Sakura", "Midnight", "Neon", "Ember", "Frost"}) do
    win:Button(tab, name, function()
        Nova:SetTheme(name)
        Nova:Notify({ title = "Theme", text = "Switched to " .. name })
    end)
end
```

---

🔔 Notification Demo

```lua
Nova:Notify({ title = "Info",    text = "This is informational" })
Nova:Notify({ title = "Success", text = "Operation completed", color = Nova.Theme.success })
Nova:Notify({ title = "Warning", text = "Low memory",          color = Nova.Theme.danger })
Nova:Notify({ title = "Custom",  text = "Purple accent",       color = Color3.fromRGB(180, 120, 255) })
```

Each notification stacks with automatic reflow — no overlap.

---

🎬 Animation System

NovaUI uses several custom animation techniques to feel alive:

Technique Where Used Effect
Back easing Window open, toggle knob, pill slide Overshoot "pop"
Staggered slide-in Every element on first tab open 30ms cascading entrance
Ripple circles Button clicks Expanding circle from center
Hover grow Buttons, close icon 2px size increase
Floating bob FAB (floating action button) Sine wave vertical motion
Rotating halo Logo/FAB Continuous 180° rotation
Pulse glow Window logo Expanding ring fade-out
Stack reflow Notifications Smooth re-position when others expire

Timing constants

· Window open: 0.45s (Back, Out)
· Element stagger: 0.03s per element (Back, Out)
· Tab pill slide: 0.35s (Back, Out)
· Toggle knob: 0.3s (Back, Out)
· Notification slide: 0.5s (Back, Out)
· Hover feedback: 0.15s (Quart, Out)

All animations can be customized by editing the pop() and anim() helper functions at the top of the file.

---

🔧 Customization

Override theme colors before creating elements

```lua
Nova:SetTheme("Aurora")
Nova.Theme.accent = Color3.fromRGB(255, 100, 200)
Nova.Theme.bg = Color3.fromRGB(15, 10, 25)
-- new elements will use the overridden colors
```

Access raw instances

Every window exposes its internal Roblox Instances for advanced customization:

```lua
win.Win       -- Main window Frame
win.Content   -- ScrollingFrame for elements
win.Rail      -- Tab bar Frame
win.Pill      -- Sliding highlight Frame
win.TabRail   -- ScrollingFrame holding tab buttons
win.Fab       -- Floating action button
win.Gui       -- ScreenGui container
```

Example — hide the FAB:

```lua
win.Fab.Visible = false
```

Example — change window position:

```lua
win.Win.Position = UDim2.new(0, 100, 0, 100)
```

Extend Nova.Items

Nova.Items contains every element you've created. Iterate it for bulk operations:

```lua
for _, item in ipairs(Nova.Items) do
    if item.SetEnabled then item.SetEnabled(false) end
end
```

Add custom themes

```lua
Nova.Palettes.MyTheme = {
    bg      = Color3.fromRGB(20, 20, 20),
    glass   = Color3.fromRGB(40, 40, 40),
    card    = Color3.fromRGB(60, 60, 60),
    accent  = Color3.fromRGB(255, 180, 0),
    accent2 = Color3.fromRGB(255, 100, 0),
    text    = Color3.fromRGB(255, 255, 255),
    sub     = Color3.fromRGB(180, 180, 180),
    danger  = Color3.fromRGB(255, 80, 80),
    success = Color3.fromRGB(80, 220, 120),
    radius  = 12,
}

Nova:SetTheme("MyTheme")
```

---

🐛 Troubleshooting

<details>
<summary><b>❌ UI doesn't appear after loading</b></summary>

· Ensure your executor supports loadstring and game:HttpGet
· Verify the URL is accessible in your browser
· Check that LocalPlayer exists when the script runs
· Try wrapping in task.wait(2) before creating the window

</details>

<details>
<summary><b>❌ Config not saving</b></summary>

· Your executor may not support writefile
· Check your executor's documentation for file API support
· Try writefile("test.txt", "hi") in the console to test

</details>

<details>
<summary><b>❌ Elements don't render in correct order</b></summary>

· NovaUI uses UIListLayout with SortOrder = LayoutOrder
· Elements appear in creation order automatically
· If you need manual ordering, set .LayoutOrder on each element's returned instance

</details>

<details>
<summary><b>❌ Notifications overlap or don't stack</b></summary>

· The Nova._notifs table tracks active notifications
· If stale, clear it manually: Nova._notifs = {}
· Notifications auto-reflow every 0.3s after each dismissal

</details>

<details>
<summary><b>❌ Tab pill doesn't slide</b></summary>

· The pill position is calculated from AbsolutePosition
· Make sure the window is visible before creating tabs
· If tabs are created while hidden, call win:Show() then win:Pick(tab) to reposition

</details>

<details>
<summary><b>❌ Theme switch doesn't update existing elements</b></summary>

· SetTheme updates window backgrounds live
· Individual element colors are set at creation time
· To fully refresh, recreate elements or manually tween each

</details>

---

❓ FAQ

<details>
<summary><b>Can I use this in a paid product?</b></summary>

Yes — MIT license permits commercial use. Attribution appreciated but not required.

</details>

<details>
<summary><b>Does it work on mobile executors?</b></summary>

Yes, NovaUI uses Enum.UserInputType.Touch handlers for dragging and sliders.

</details>

<details>
<summary><b>How many tabs can I have?</b></summary>

Unlimited. The tab rail scrolls horizontally.

</details>

<details>
<summary><b>Can I have multiple windows?</b></summary>

Yes — call Nova.new() multiple times. Each window is independent.

```lua
local win1 = Nova.new({ Title = "Main" })
local win2 = Nova.new({ Title = "Secondary" })
```

</details>

<details>
<summary><b>How do I disable the FAB?</b></summary>

```lua
win.Fab.Visible = false
```

</details>

<details>
<summary><b>Can I change the ripple color?</b></summary>

Edit the ripple(b, Nova.Theme.bg) call in Nova:Button or pass a custom color:

```lua
ripple(b, Color3.fromRGB(255, 0, 0))
```

</details>

<details>
<summary><b>Where are saved configs stored?</b></summary>

In your executor's workspace folder. The default filename is NovaConfig.json.

</details>

<details>
<summary><b>Can I contribute?</b></summary>

Yes! Fork, make your changes, and open a pull request. Issues and feature requests are welcome.

</details>

---

📊 Project Stats

Metric Value
Lines of code ~1100
Components 9 (window, tab, section, label, button, toggle, slider, dropdown, textbox, keybind)
Themes 6
Dependencies 0
File size ~38 KB

---

🗺️ Roadmap

☐ Color picker element
☐ Multi-column layouts
☐ Resizable window
☐ Auto-save on flag change (debounced)
☐ Built-in search/filter for elements
☐ Watermark / branding toggle
☐ Rebindable FAB position

---

📄 License

```
MIT License

Copyright (c) 2025 NovaUI

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

👤 Credits

NovaUI was built from scratch as a modern alternative to existing Roblox UI libraries, with animation inspiration from Jily-style interfaces.

Special thanks to the Roblox UI community for the inspiration and feedback.

---

<div align="center">

⭐ If NovaUI helped you build something cool, star the repo! ⭐

Made with 💜 and way too many tweens.

</div>

---

📋 Copy-Paste Version (for quick use)

If you just need the entire README in one block (e.g., to paste into GitHub's README editor), here it is:

<details>
<summary><b>📋 Click to expand full markdown source</b></summary>

```markdown
# NovaUI — Fluid Edition

A beautiful, animation-rich Roblox UI library with Jily-style spring physics, glass morphism, and staggered entrance animations.

## Features

- Spring physics animations (Back easing pop)
- Glass morphism surfaces
- Sliding tab highlight pill
- Staggered entrance animations
- Ripple click effects
- 6 themes (Aurora, Sakura, Midnight, Neon, Ember, Frost)
- Stacked notifications with reflow
- Floating FAB with rotating halo
- Config save/load (JSON)
- Hotkey toggle
- Zero dependencies

## Installation

```lua
local Nova = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/NovaUI.lua"))()
```

## Quick Start

```lua
local Nova = loadstring(game:HttpGet("YOUR_URL"))()

local win = Nova.new({
    Title = "My Hub",
    Icon = "✦",
})

local main = win:Tab("Main")
win:Section(main, "Combat")
win:Toggle(main, "Auto Aim", false, "aim", function(s) print(s) end)
win:Slider(main, "FOV", 10, 360, 90, "fov", function(v) print(v) end)
win:Button(main, "Execute", function()
    Nova:Notify({ title = "Done", text = "Executed!" })
end)
```

## API

### Window
- `Nova.new(config)` — Create window
- `win:Show()` / `win:Hide()` / `win:Toggle()`
- `win:Tab(name)` — Create tab
- `win:Pick(tab)` — Switch tab

### Elements
- `win:Section(tab, text)`
- `win:Label(tab, text)`
- `win:Button(tab, label, callback, color?)`
- `win:Toggle(tab, label, default, flag, callback)`
- `win:Slider(tab, label, min, max, default, flag, callback)`
- `win:Dropdown(tab, label, options, default, flag, callback)`
- `win:Textbox(tab, label, placeholder, default, flag, callback)`
- `win:Keybind(tab, label, default, flag, callback)`

### System
- `Nova:Notify(config)` — Stacked notifications
- `Nova:SetTheme(name)` — Live theme switch
- `Nova:Save(file?)` / `Nova:Load(file?)` — Config persistence

## Themes

`Aurora` · `Sakura` · `Midnight` · `Neon` · `Ember` · `Frost`

## License

MIT
```

</details>
