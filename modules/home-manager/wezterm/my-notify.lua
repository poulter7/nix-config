local wezterm = require("wezterm")
local M = {}

local function has_value(tab, val)
	for index, value in ipairs(tab) do -- luacheck: ignore 213
		if value == val then
			return true
		end
	end

	return false
end

function M.send(subject, msg, urgency)
	local allowed_urgency = { "low", "normal", "critical" }
	urgency = urgency or "normal"
	if not has_value(allowed_urgency, urgency) then
		urgency = "normal"
	end

	wezterm.run_child_process({
		"notify-send",
		"-",
		"org.wezfurlong.wezterm",
		"-a",
		"wezterm",
		"-u",
		urgency,
		subject,
		msg,
	})
end

return M
