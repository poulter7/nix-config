local wezterm = require("wezterm")
local colors = require("colors")

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
-- resurrect.change_state_save_dir("/Users/jonathan/temp/")
-- resurrect.save_state_dir = "/Users/jonathan/temp/"

resurrect.periodic_save({ interval_seconds = 1 * 60, save_workspaces = true, save_windows = false, save_tabs = false })

wezterm.on("resurrect.periodic_save", function()
	resurrect.write_current_state(wezterm.mux.get_active_workspace(), "workspace")
end)

local function toast(window, message)
	window:toast_notification("wezterm", message .. " - " .. os.date("%I:%M:%S %p"), nil, 1000)
end

wezterm.on("window-config-reloaded", function(window, pane)
	toast(window, "Configuration reloaded!")
end)

wezterm.on("gui-startup", resurrect.resurrect_on_gui_startup)

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
			local workspace_state = resurrect.workspace_state
			resurrect.save_state(workspace_state.get_workspace_state())
			resurrect.write_current_state(wezterm.mux.get_active_workspace(), "workspace")
			toast(win, "Saved workspace state")
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

return M
