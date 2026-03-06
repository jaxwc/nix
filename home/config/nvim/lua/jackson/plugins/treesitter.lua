return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master", 
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        ensure_installed = {
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
        },
        highlight = { enable = true },
        indent = { enable = true }, 

      })
    end
  }
}
