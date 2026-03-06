local settings = require("settings")
local colors = require("colors")
local sbar = require("sketchybar")

local cal = sbar.add("item", "calendar", {
	position = "right",
	update_freq = 30,

	icon = {
		drawing = false,
	},

	label = {
		color = colors.cyan,
		width = "dynamic",

		padding_left = settings.paddings,
	},
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ label = os.date("%H:%M") })
end)
