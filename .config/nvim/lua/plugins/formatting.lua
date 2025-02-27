return {
	"stevearc/conform.nvim",
	event = { "VeryLazy" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier", "prettierd" },
				typescript = { "prettier", "prettierd" },
				lua = { "stylua" },
				python = { "isort", "black" },
				html = { "prettier" },
				json = { "prettier" },
				sh = { "shfmt", "beautysh" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
			formatters = {
				["clang-format"] = {
					prepend_args = {
						"-style={ \
                        IndentWidth: 4, \
                        TabWidth: 4, \
                        UseTab: Never, \
                        AccessModifierOffset: 0, \
                        IndentAccessModifiers: true, \
                        PackConstructorInitializers: Never}",
					},
				},
			},
		})
		vim.keymap.set("n", "<leader>gf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format Manually" })
	end,
}
