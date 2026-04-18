return {
	"folke/tokyonight.nvim",
	name = "folkeTokyonight",
	config = function()
		local transparent = true
		local bg = "#0b0918"
		local bg_dark = "#07050f"
		local bg_float = "#16092f"
		local bg_highlight = "#28176a"
		local bg_popup = "#1d1148"
		local bg_search = "#4526b8"
		local bg_visual = "#6a39dc"

		local fg = "#f1ebff"
		local fg_dark = "#d0c7f4"
		local fg_gutter = "#3b3168"
		local fg_sidebar = "#ddd5fb"
		local comment = "#7a72a8"
		local dark3 = "#655d92"
		local dark5 = "#a198ce"

		local black = "#05030a"
		local border = "#29155f"
		local border_highlight = "#35e8ff"
		local terminal_black = "#342d62"

		local red = "#ff4b87"
		local red1 = "#ff1f6d"
		local orange = "#ffb347"
		local yellow = "#ffe066"
		local green = "#2cf0cb"
		local green1 = "#82ffe4"
		local green2 = "#19c7ab"
		local cyan = "#35e8ff"
		local blue = "#5f86ff"
		local blue0 = "#2b37a3"
		local blue1 = "#35e8ff"
		local blue2 = "#11c8ff"
		local blue5 = "#97edff"
		local blue6 = "#d6fbff"
		local blue7 = "#3c4690"
		local magenta = "#ff38c8"
		local magenta2 = "#ff00a8"
		local purple = "#b18cff"
		local teal = "#14d0db"

		require("tokyonight").setup({
			style = "storm",
			transparent = transparent,

			styles = {
				comments = { italic = false },
				keywords = { italic = true },
				sidebars = transparent and "transparent" or "dark",
				floats = transparent and "transparent" or "dark",
			},
			on_colors = function(colors)
				colors.bg = transparent and colors.none or bg
				colors.bg_dark = transparent and colors.none or bg_dark
				colors.bg_float = transparent and colors.none or bg_float
				colors.bg_highlight = bg_highlight
				colors.bg_popup = bg_popup
				colors.bg_search = bg_search
				colors.bg_sidebar = transparent and colors.none or bg_dark
				colors.bg_statusline = transparent and colors.none or bg_dark
				colors.bg_visual = bg_visual

				colors.black = black
				colors.border = border
				colors.border_highlight = border_highlight
				colors.comment = comment
				colors.dark3 = dark3
				colors.dark5 = dark5
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_sidebar
				colors.terminal_black = terminal_black

				colors.red = red
				colors.red1 = red1
				colors.orange = orange
				colors.yellow = yellow
				colors.green = green
				colors.green1 = green1
				colors.green2 = green2
				colors.cyan = cyan
				colors.blue = blue
				colors.blue0 = blue0
				colors.blue1 = blue1
				colors.blue2 = blue2
				colors.blue5 = blue5
				colors.blue6 = blue6
				colors.blue7 = blue7
				colors.magenta = magenta
				colors.magenta2 = magenta2
				colors.purple = purple
				colors.teal = teal

				colors.error = red1
				colors.warning = yellow
				colors.info = cyan
				colors.hint = green
				colors.todo = purple

				colors.diff = {
					add = "#123c35",
					delete = "#4a1830",
					change = "#2a235a",
					text = bg_highlight,
				}

				colors.git = {
					add = green2,
					change = blue,
					delete = red,
					ignore = dark3,
				}

				colors.rainbow = {
					blue,
					yellow,
					green,
					teal,
					magenta,
					purple,
					orange,
					red,
				}

				colors.terminal = {
					black = black,
					black_bright = terminal_black,
					red = red,
					red_bright = red1,
					green = green,
					green_bright = green1,
					yellow = yellow,
					yellow_bright = yellow,
					blue = blue,
					blue_bright = blue1,
					magenta = magenta,
					magenta_bright = purple,
					cyan = cyan,
					cyan_bright = blue5,
					white = fg_dark,
					white_bright = fg,
				}
			end,
			on_highlights = function(hl, c)
				hl.NormalFloat = { bg = transparent and c.none or bg_float, fg = fg }
				hl.FloatBorder = { bg = transparent and c.none or bg_float, fg = border_highlight }
				hl.FloatTitle = { bg = transparent and c.none or bg_float, fg = magenta }

				hl.Pmenu = { bg = transparent and c.none or bg_popup, fg = fg }
				hl.PmenuMatch = { bg = transparent and c.none or bg_popup, fg = blue1 }
				hl.PmenuSel = { bg = bg_highlight, fg = cyan, bold = true }
				hl.PmenuMatchSel = { bg = bg_highlight, fg = blue1, bold = true }
				hl.PmenuSbar = { bg = transparent and c.none or bg_popup }
				hl.PmenuThumb = { bg = purple }

				hl.Search = { bg = yellow, fg = bg_dark }
				hl.IncSearch = { bg = magenta, fg = bg_dark }
				hl.Visual = { bg = bg_visual }

				hl.CursorLine = { bg = bg_highlight }
				hl.StatusLine = { bg = transparent and c.none or bg_dark, fg = fg_dark }
				hl.StatusLineNC = { bg = transparent and c.none or bg_dark, fg = comment }

				hl.DiagnosticVirtualTextError = { bg = bg_float, fg = red }
				hl.DiagnosticVirtualTextWarn = { bg = bg_float, fg = yellow }
				hl.DiagnosticVirtualTextInfo = { bg = bg_float, fg = cyan }
				hl.DiagnosticVirtualTextHint = { bg = bg_float, fg = green }
			end,
		})

		vim.cmd.colorscheme("tokyonight-storm")
	end,
}
