return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			local servers = {
				"nixd",
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"graphql",
				"pyright",
				"eslint",
				"clangd",
				"jdtls",
				"jsonls",
				"yamlls",
				"bashls",
			}

			for _, server in ipairs(servers) do
				vim.lsp.enable(server)
			end
		end,
	},
}
