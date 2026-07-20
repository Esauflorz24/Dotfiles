return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.config")
		config.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "bash", "markdown", "markdown_inline" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
