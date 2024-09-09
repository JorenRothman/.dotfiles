local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font 'Fira Code'
config.font_size = 16
config.enable_tab_bar = false

config.window_frame = {
    font = wezterm.font 'Fira Code',
    font_size = 12.0,
}

config.colors = {
    tab_bar = {
        active_tab = {
            bg_color = '#f5bde6',
            fg_color = '#181926'
        }
    }
}

return config