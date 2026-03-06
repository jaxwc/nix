return {
	black = 0xff100f0f,
	white = 0xffcecdc3,
	red = 0xffd14d41,
	green = 0xff879a39,
	blue = 0xff4385be,
	yellow = 0xffd0a215,
	orange = 0xffda702c,
	magenta = 0xffce5d97,
	cyan = 0xff3aa99f,
	purple = 0xff8b7ec8,
	grey = 0xff878580,
	transparent = 0x00000000,
	bar = {
		bg = 0xf0100f0f,
		border = 0xff100f0f,
	},
	popup = {
		bg = 0xc0100f0f,
		border = 0xff878580,
	},
	bg1 = 0xff100f0f,
	bg2 = 0xff1c1b1a,
	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
