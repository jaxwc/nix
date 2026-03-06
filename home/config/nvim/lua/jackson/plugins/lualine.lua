return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nuvic/flexoki-nvim", "nvim-tree/nvim-web-devicons" },
	config = function()
		local mode = {
			"mode",
			fmt = function(str)
				return " " .. str
			end,
		}

		local diff = {
			"diff",
			colored = true,
			symbols = { added = " ", modified = " ", removed = " " },
		}

		local branch = {
			"branch",
			icon = "",
		}

		local filename = {
			"filename",
			file_status = true,
			path = 0,
		}

		require("lualine").setup({
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "|", right = "" },
				globalstatus = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = { diff, filename },
				lualine_x = {
					{ "filetype" },
				},
			},
		})
	end,
}
