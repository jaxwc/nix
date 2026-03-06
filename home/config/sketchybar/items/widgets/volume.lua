local colors = require("colors")
local icons = require("icons")
local sbar = require("sketchybar")

local volume = sbar.add("item", "volume", {
	position = "right",

	icon = {
		string = icons.volume._100,
		color = colors.yellow,
	},

	label = {
		string = "??%",
		color = colors.yellow,
	},
})

volume:subscribe("volume_change", function(env)
	local vol = tonumber(env.INFO)
	local icon = icons.volume._0

	if vol > 60 then
		icon = icons.volume._100
	elseif vol > 30 then
		icon = icons.volume._66
	elseif vol > 10 then
		icon = icons.volume._33
	elseif vol > 0 then
		icon = icons.volume._10
	end

	volume:set({
		icon = { string = icon },
		label = { string = vol .. "%" },
	})
end)
