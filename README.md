# Dotfiles

Personal configuration files for Arch Linux with Hyprland.

## Installation

```bash
# Apply all configurations
stow -t ~ hyprland waybar xcompose nautilus scripts

# Or apply individually
stow hyprland    # Hyprland configs
stow waybar      # Waybar config
stow xcompose    # XCompose shortcuts
stow nautilus    # Nautilus scripts 
stow scripts    # Scripts
stow espanso    # Espanso snippets

# Restart Espanso
espanso service restart

# Add scripts to PATH
echo 'export PATH="$HOME/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Adopting a configuration after changes (e.g. a system update)
stow -t ~ --adopt waybar
```