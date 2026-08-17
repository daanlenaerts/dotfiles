# Dotfiles

Personal configuration files for Arch Linux with Omarchy 4 (Hyprland).

Hyprland is configured in Lua since Omarchy 4 — the old `~/.config/hypr/*.conf`
files are no longer read. Omarchy's defaults load first, so the files here only
carry personal overrides.

## Installation

```bash
# Apply all configurations
stow -t ~ hyprland omarchy xcompose nautilus scripts espanso cursor vscode

# Or apply individually
stow -t ~ hyprland    # Hyprland overrides (bindings.lua, input.lua, monitors.lua)
stow -t ~ omarchy     # Omarchy themes (daan-theme, daan-forest) and theme-set hooks
stow -t ~ xcompose    # XCompose shortcuts
stow -t ~ nautilus    # Nautilus scripts
stow -t ~ scripts     # Scripts
stow -t ~ espanso     # Espanso snippets
stow -t ~ cursor      # Cursor user settings and keybindings
stow -t ~ vscode      # VS Code user settings


# Apply a theme
omarchy theme set daan-theme
omarchy theme set daan-forest

# Per-monitor workspaces (not stowed; install via Omarchy)
omarchy plugin add https://github.com/mmsbrggr/omarchy-per-monitor-workspaces.git --enable
omarchy bar set mmsbrggr.per-monitor-workspaces count 10 --json

# Restart Espanso
espanso service restart

# Add scripts to PATH
echo 'export PATH="$HOME/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Adopting a configuration after changes (e.g. a system update)
stow -t ~ --adopt hyprland
```

## Per-monitor workspaces

Each screen gets its own 1–10 slots, so `SUPER+3` is *this* screen's third
workspace rather than a global one that might live on the other monitor.

The plugin is a third-party Omarchy clone, not part of this repo. Stow
`hyprland` anyway: `bindings.lua` loads it with `pcall`, so a missing plugin
skips those keys instead of breaking the rest of the file. `SUPER+A` /
`SUPER+D` cycle this screen's slots once the plugin is present.

```bash
omarchy plugin add https://github.com/mmsbrggr/omarchy-per-monitor-workspaces.git --enable
omarchy bar set mmsbrggr.per-monitor-workspaces count 10 --json
```

`SUPER+1` through `SUPER+0` then map to this screen's slots (`0` is 10). The
count lives on the bar widget in `~/.config/omarchy/shell.json`, which this
repo does not stow.

## GTK / Nautilus theme

`omarchy theme set` writes the current `colors.toml` into `~/.config/gtk-4.0/gtk.css`
and `~/.config/gtk-3.0/gtk.css` (libadwaita named colours, including Nautilus).
The hook is installed by `stow -t ~ omarchy`. Reopen Files to reload; other
libadwaita apps pick up the same palette. Themes without `colors.toml` drop the
managed CSS block so Adwaita defaults return.

## Codex theme (daan-forest)

daan-forest includes a Codex desktop appearance string at
`omarchy/.config/omarchy/themes/daan-forest/codex-theme-v1`.

**Auto-apply:** `stow -t ~ omarchy` installs a `theme-set` hook. After that,
`omarchy theme set daan-forest` writes the palette into `~/.codex/config.toml`
(`appearanceLightCodeThemeId` and `[desktop.appearanceLightChromeTheme]`).
Restart Codex so the desktop app reloads the config. Themes without a
`codex-theme-v1` file drop that overlay so Codex defaults return.

**Manual import:** Codex Settings → Appearance → Light Theme → Import, then
paste the contents of that file:

```
codex-theme-v1:{"codeThemeId":"codex","theme":{"accent":"#5b7146","contrast":45,"fonts":{"code":null,"ui":null},"ink":"#123b30","opaqueWindows":false,"semanticColors":{"diffAdded":"#2ea043","diffRemoved":"#f85149","skill":"#77607d"},"surface":"#f1f3ea"},"variant":"light"}
```

`codeThemeId` must stay a built-in Codex id (`codex`, `github-light`, `one`,
…) or the in-app importer will refuse the payload. Chrome colors still come
from the JSON `theme` object.

## Thunderbird theme (daan-forest)

daan-forest includes a Thunderbird WebExtension theme at
`omarchy/.config/omarchy/themes/daan-forest/thunderbird/`.

**Auto-apply:** `stow -t ~ omarchy` installs a `theme-set` hook. After that,
`omarchy theme set daan-forest` sideloads the theme into each Thunderbird
profile, selects it via `user.js`, and tints the default message-body canvas
(`userContent.css` plus `browser.display.background_color`). Restart
Thunderbird so it reloads the add-on and stylesheets. Themes without a
`thunderbird/manifest.json` remove the sideloaded add-on and restore
Thunderbird's default theme.

**Manual install:** Thunderbird Add-ons Manager → gear → Install Add-on From
File, then choose a packed `daan-forest@themes.daanlenaerts.com.xpi` (the hook
writes that file into each profile's `extensions/` directory).

## LibreOffice theme (daan-forest)

daan-forest includes a LibreOffice appearance theme at
`omarchy/.config/omarchy/themes/daan-forest/libreoffice/`, tuned for Calc:
moss sheet canvas, a quiet grid, header and KPI fills, and a 12-color chart
series.

**Auto-apply:** `stow -t ~ omarchy` installs a `theme-set` hook. After that,
`omarchy theme set daan-forest` writes the **Daan Forest** color scheme into
LibreOffice, selects the matching palettes, and copies the document theme used
by Format → Theme. Restart LibreOffice so it reloads the registry. Themes
without a `libreoffice/Theme.xcu` remove that color scheme and palettes so
LibreOffice's default appearance returns.

**Manual install:** Tools → Extension Manager → Add, then choose a packed
`com.daanlenaerts.daan-forest.libreoffice.oxt` (zip the `libreoffice/` folder
contents). After install, pick **Daan Forest** under Tools → Options →
LibreOffice → Appearance. In Calc, Format → Theme lists the same palette for
headers, accents, and charts.