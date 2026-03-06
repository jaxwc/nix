return {
  "stevearc/oil.nvim",
  dependencies = {
    { "echasnovski/mini.icons", lazy = false },
    { "nvim-tree/nvim-web-devicons" }
  },
  config = function()
    local oil = require("oil")

    oil.setup({

            keymaps = {
				["<C-h>"] = false,
                ["<C-c>"] = false,
                ["q"] = "actions.close",
			},


    delete_to_trash = true,
    view_options = {
            show_hidden = false,
    },
})

    vim.keymap.set("n", "-", oil.toggle_float, {})
         vim.api.nvim_create_autocmd("FileType", {
            pattern = "oil", -- Adjust if Oil uses a specific file type identifier
            callback = function()
                vim.opt_local.cursorline = true
            end,
        })
  end,
  lazy = false,
}
