return {
	"folke/tokyonight.nvim",
	name = "folkeTokyonight",
	config = function()
		local theme_path = vim.fs.dirname(vim.fn.stdpath("config")) .. "/nix-theme/nvim.json"
		local theme = vim.json.decode(table.concat(vim.fn.readfile(theme_path), "\n"))
		local c = theme.colors
		local transparent = theme.transparent
		local bg, bg_dark, bg_float = c.bg, c.bg_dark, c.bg_float
		local bg_highlight, bg_popup, bg_search, bg_visual = c.bg_highlight, c.bg_popup, c.bg_search, c.bg_visual
		local fg, fg_dark, fg_gutter, fg_sidebar = c.fg, c.fg_dark, c.fg_gutter, c.fg_sidebar
		local comment, dark3, dark5 = c.comment, c.dark3, c.dark5
		local black, border, border_highlight, terminal_black = c.black, c.border, c.border_highlight, c.terminal_black
		local red, red1, orange, yellow = c.red, c.red1, c.orange, c.yellow
		local green, green1, green2 = c.green, c.green1, c.green2
		local cyan, blue, blue0, blue1 = c.cyan, c.blue, c.blue0, c.blue1
		local blue2, blue5, blue6, blue7 = c.blue2, c.blue5, c.blue6, c.blue7
		local magenta, magenta2, purple, teal = c.magenta, c.magenta2, c.purple, c.teal

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
					add = c.diff_add,
					delete = c.diff_delete,
					change = c.diff_change,
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
