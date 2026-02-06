# xremap: Signal Escape Key Fix

Remap Escape → Ctrl+Shift+C in Signal (closes conversation).

## Install

```bash
cargo install xremap --features hypr
```

## Permissions (run without sudo)

```bash
sudo usermod -aG input $USER
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-uinput.rules
sudo modprobe uinput
```

Load uinput at boot:
```bash
echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf
```

Log out and back in.

## Config

`~/.config/xremap/config.yml`:
```yaml
keymap:
  - name: Signal Escape closes chat
    application:
      only: signal
    remap:
      ESC: C-Shift-c
```

## Autostart

Add to `~/.config/hypr/hyprland.conf`:
```
exec-once = sleep 1 && xremap ~/.config/xremap/config.yml
```
