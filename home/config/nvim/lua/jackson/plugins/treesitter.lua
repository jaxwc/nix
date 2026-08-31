local languages = {
	"python",
	"c",
	"cpp",
	"bash",
	"html",
	"javascript",
	"typescript",
	"json",
	"lua",
	"css",
	"vim",
	"markdown",
	"markdown_inline",
	"toml",
	"yaml",
	"java",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			treesitter.setup({})
			treesitter.install(languages)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"python",
					"c",
					"cpp",
					"sh",
					"html",
					"javascript",
					"typescript",
					"json",
					"lua",
					"css",
					"vim",
					"markdown",
					"toml",
					"yaml",
					"java",
				},
				callback = function()
					vim.treesitter.start()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
