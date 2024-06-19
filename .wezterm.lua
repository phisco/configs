-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'catppuccin-mocha'
-- config.color_scheme = 'OneHalfDark'
config.color_scheme = 'Dracula'
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold', italic = false })

config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'
config.window_padding = {
  left = 5,
  right = 5,
  top = 20,
  bottom = 5,
}

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- Set the correct window size at the startup
wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  -- Open full screen
  window:gui_window():maximize()
end)

config.selection_word_boundary = '{}[]()"\'`,;:─│┬┤ '

-- and finally, return the configuration to wezterm
return config
