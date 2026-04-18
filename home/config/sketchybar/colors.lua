return {
	black = 0xff05030a,
	white = 0xfff1ebff,
	red = 0xffff4b87,
	green = 0xff2cf0cb,
	blue = 0xff5f86ff,
	yellow = 0xffffe066,
	orange = 0xffffb347,
	magenta = 0xffff38c8,
	cyan = 0xff35e8ff,
	purple = 0xffb18cff,
	grey = 0xff7a72a8,
	transparent = 0x00000000,
	bar = {
		bg = 0xf007050f,
		border = 0xff29155f,
	},
	popup = {
		bg = 0xe016092f,
		border = 0xff35e8ff,
	},
	bg1 = 0xff16092f,
	bg2 = 0xff28176a,
	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
