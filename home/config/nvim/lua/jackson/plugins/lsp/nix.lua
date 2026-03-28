return {
	{
		"neovim/nvim-lspconfig",
		ft = { "nix" },
		config = function()
			vim.lsp.enable("nixd")
		end,
	},
}
