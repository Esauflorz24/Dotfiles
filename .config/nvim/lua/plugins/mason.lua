return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
                border = "double",
                width = 0.8,
                height = 0.8,
            },
        })

        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "pyright",
                "bashls",
                "tsserver",
            },
            automatic_installation = true,
        })

        mason_tool_installer.setup({
            ensure_installed = {
                { "bash-language-server" },
                { "lua-language-server" },
                { "vim-language-server" },
                { "stylua" },
                { "editorconfig-checker" },
                { "html-lsp" },
                { "emmet-ls" },
                { "pyright" },
                { "black" },
                { "autopep8" },
                { "json-lsp" },
                { "prettier" },
                { "typescript-language-server" },
                { "js-debug-adapter" },
                { "eslint_d" },
                { "eslint-lsp" },
                { "codelldb" },
                { "clangd" },
                { "clang-format" },
            },

            auto_update = true,
            run_on_start = true,
            start_delay = 3000,
            debounce_hours = 5,
        })
    end,
}
