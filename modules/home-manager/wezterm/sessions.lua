local wezterm = require("wezterm")
local colors = require("colors")

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

resurrect.periodic_save({ interval_seconds = 1, save_workspaces = true, save_windows = true, save_tabs = true })

local function toast(window, message)
	window:toast_notification("wezterm", message .. " - " .. os.date("%I:%M:%S %p"), nil, 1000)
end

wezterm.on("window-config-reloaded", function(window, pane)
	toast(window, "Configuration reloaded!")
end)

-- local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

wezterm.on("augment-command-palette", function(window, pane)
	local workspace_state = resurrect.workspace_state
	return {
		-- {
		-- 	brief = "Window | Workspace: Switch Workspace",
		-- 	icon = "md_briefcase_arrow_up_down",
		-- 	action = workspace_switcher.switch_workspace(),
		-- },
		{
			brief = "Window | Workspace: Rename Workspace",
			icon = "md_briefcase_edit",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for workspace",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
						resurrect.save_state(workspace_state.get_workspace_state())
					end
				end),
			}),
		},
	}
end)
-- wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
-- 	window:gui_window():set_right_status(wezterm.format({
-- 		{ Attribute = { Intensity = "Bold" } },
-- 		{ Foreground = { Color = colors.colors.ansi[5] } },
-- 		{ Text = basename(path) .. "  " },
-- 	}))
-- 	local workspace_state = resurrect.workspace_state
--
-- 	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
-- 		window = window,
-- 		relative = true,
-- 		restore_text = true,
-- 		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
-- 	})
-- end)
--
-- wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
-- 	wezterm.log_info(window)
-- 	window:gui_window():set_right_status(wezterm.format({
-- 		{ Attribute = { Intensity = "Bold" } },
-- 		{ Foreground = { Color = colors.colors.ansi[5] } },
-- 		{ Text = basename(path) .. "  " },
-- 	}))
-- end)
--
-- wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
-- 	wezterm.log_info(window)
-- 	local workspace_state = resurrect.workspace_state
-- 	resurrect.save_state(workspace_state.get_workspace_state())
-- 	resurrect.write_current_state(label, "workspace")
-- end)
--
local keys = {
	{
		key = "D",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id)
				resurrect.delete_state(id)
			end, {
				title = "Delete State",
				description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
				fuzzy_description = "Search State to Delete: ",
				is_fuzzy = true,
			})
		end),
	},
	{
		key = "R",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			toast(win, "Saved state")
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},
}

local M = {}

function M.setup_sessions(config)
	config.keys = config.keys or {}
	for _, key in ipairs(keys) do
		table.insert(config.keys, key)
	end
	return config
end

-- wezterm.on("gui-startup", resurrect.resurrect_on_gui_startup)
return M
