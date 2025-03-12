local wezterm = require("wezterm")

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local is_windows = function()
	return not (is_darwin() or is_linux())
end

local config = {}

config = wezterm.config_builder()
if is_windows() then
	if wezterm.config_builder then
		config = wezterm.config_builder()
	end

	-- change config now
	config.default_domain = "WSL:Ubuntu"
end
config.font = wezterm.font("CommitMono Nerd Font")

config.enable_wayland = false
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_frame = {
	-- Berkeley Mono for me again, though an idea could be to try a
	-- serif font here instead of monospace for a nicer look?
	font = wezterm.font({ family = "CommitMono Nerd Font", weight = "Bold" }),
	font_size = 11,
}
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30

config.default_workspace = "default"
config.color_scheme = "kanagawabones"
config.cursor_blink_rate = 750
config.inactive_pane_hsb = {
	brightness = 0.5,
	saturation = 0.7,
}
config.window_padding = {
	top = 10,
	bottom = 0,
	left = 0,
	right = 0,
}
wezterm.on("update-status", function(window)
	-- Grab the utf8 character for the "powerline" left facing
	-- solid arrow.
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Grab the current window's configuration, and from it the
	-- palette (this is the combination of your chosen colour scheme
	-- including any overrides).
	local color_scheme = window:effective_config().resolved_palette
	local bg = color_scheme.background
	local fg = color_scheme.foreground

	window:set_right_status(wezterm.format({
		-- First, we draw the arrow...
		{ Background = { Color = "none" } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_LEFT_ARROW },
		-- Then we draw our text
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. wezterm.hostname() .. " " },
	}))
end)

return config
