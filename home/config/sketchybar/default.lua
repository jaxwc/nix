local settings = require("settings")
local colors = require("colors")
local sbar = require("sketchybar")

sbar.default({
  updates = "when_shown",
  
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style,
      size = 12.0
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    y_offset = 0,
  },
  
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style,
      size = 12.0
    },
    color = colors.white,
    padding_right = settings.paddings,
    y_offset = 0,
  },
  
  background = {
	color = colors.bg1,
    height = 28,
    corner_radius = 14,
  },

  padding_left = settings.group_paddings,
  padding_right = settings.group_paddings,
  scroll_texts = true,
})
