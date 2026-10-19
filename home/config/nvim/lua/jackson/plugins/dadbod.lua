return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql" }, lazy = true },
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DB UI" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
			vim.g.db_ui_execute_on_save = 0

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql" },
				callback = function(ev)
					vim.keymap.set(
						{ "n", "x" },
						"<leader>r",
						"<Plug>(DBUI_ExecuteQuery)",
						{ buffer = ev.buf, desc = "Run SQL" }
					)
				end,
			})
		end,
	},
}
