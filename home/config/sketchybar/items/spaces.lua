local colors = require("colors")
local sbar = require("sketchybar")
local settings = require("settings")

local config = {
	icon_on = "●",
	icon_off = "○",
}

sbar.exec("@PROFILE_BIN@/aerospace list-workspaces --all", function(output)
	local spaces = {}

	for space_name in output:gmatch("[^\r\n]+") do
		local space = sbar.add("item", "space." .. space_name, {
			icon = {
				font = { size = 20.0 },
				string = config.icon_off,
				color = colors.grey,

				width = 20,
				align = "center",
			},
			label = { drawing = false },
			background = { drawing = false },

			padding_left = 2,
			padding_right = 2,

			click_script = "@PROFILE_BIN@/aerospace workspace " .. space_name,
		})

		table.insert(spaces, space.name)

		space:subscribe("aerospace_workspace_change", function(env)
			local selected = (env.FOCUSED_WORKSPACE == space_name)
			sbar.animate("circ", 15, function()
				space:set({
					icon = {
						string = selected and config.icon_on or config.icon_off,
						color = selected and colors.cyan or colors.grey,
					},
				})
			end)
		end)
	end

	sbar.set(spaces[1], { padding_left = settings.paddings })
	sbar.set(spaces[#spaces], { padding_right = settings.paddings })

	sbar.add("bracket", spaces, {})
end)
