return {
	"nuvic/flexoki-nvim",
	name = "flexoki",
	lazy = false,
	priority = 1000,
	config = function()
		require("flexoki").setup({
			variant = "moon",
			styles = {
				bold = true,
				italic = false,
			},
			highlight_groups = {
				Normal = { bg = "NONE" },
				NormalNC = { bg = "NONE" },
				NormalFloat = { bg = "NONE" },
				FloatBorder = { bg = "NONE" },
				SignColumn = { bg = "NONE" },
				EndOfBuffer = { bg = "NONE" },
			},
		})
		vim.cmd("colorscheme flexoki")
	end,
}
