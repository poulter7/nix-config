local wezterm = require("wezterm")
local sessions = require("sessions")

-- nav
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end
local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local is_windows = function()
	return not (is_darwin() or is_linux())
end
local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
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
config.default_workspace = "default"
config.color_scheme = "kanagawabones"
config.cursor_blink_rate = 750
config.inactive_pane_hsb = {
	brightness = 0.5,
	saturation = 0.7,
}
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.window_padding = {
	bottom = 0,
}
config.keys = {
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateCommandPalette },
	-- splitting
	{ key = "d", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ShowTabNavigator,
	},
	{
		mods = "LEADER",
		key = "Space",
		action = wezterm.action.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

sessions.setup_sessions(config)

return config
