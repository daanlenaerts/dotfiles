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
stow -t ~ omarchy     # Omarchy themes (daan-theme, daan-forest) and Codex hook
stow -t ~ xcompose    # XCompose shortcuts
stow -t ~ nautilus    # Nautilus scripts
stow -t ~ scripts     # Scripts
stow -t ~ espanso     # Espanso snippets
stow -t ~ cursor      # Cursor user settings and keybindings
stow -t ~ vscode      # VS Code user settings


# Apply a theme
omarchy theme set daan-theme
omarchy theme set daan-forest

# Restart Espanso
espanso service restart

# Add scripts to PATH
echo 'export PATH="$HOME/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Adopting a configuration after changes (e.g. a system update)
stow -t ~ --adopt hyprland
```

## Codex theme (daan-forest)

daan-forest includes a Codex desktop appearance string at
`omarchy/.config/omarchy/themes/daan-forest/codex-theme-v1`.

**Auto-apply:** `stow -t ~ omarchy` installs a `theme-set` hook. After that,
`omarchy theme set daan-forest` writes the palette into `~/.codex/config.toml`
(`appearanceLightCodeThemeId` and `[desktop.appearanceLightChromeTheme]`).
Restart Codex so the desktop app reloads the config. Themes without a
`codex-theme-v1` file are left unchanged.

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
`thunderbird/manifest.json` are left unchanged.

**Manual install:** Thunderbird Add-ons Manager → gear → Install Add-on From
File, then choose a packed `daan-forest@themes.daanlenaerts.com.xpi` (the hook
writes that file into each profile's `extensions/` directory).