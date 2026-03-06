local colors = require("colors")
local icons = require("icons")
local sbar = require("sketchybar")

local apple = sbar.add("item", "apple", {
	position = "left",
	icon = {
		string = icons.apple,
		color = colors.cyan,

		font = {
			size = 14.0,
		},

		padding_left = 10,
		padding_right = 10,

		y_offset = 0,
	},
	label = { drawing = false },
})
