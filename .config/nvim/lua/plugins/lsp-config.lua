return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "clangd", "pyright" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            local lspconfig = require("lspconfig")
            local function on_attach(client, bufnr)
                local function opts(desc)
                    return { buffer = bufnr, desc = "LSP " .. desc }
                end
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("hover"))
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

                client.server_capabilities.signatureHelpProvider = false
                client.server_capabilities.semanticTokensProvider = true
            end
            local signs = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " ",
            }

            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            local servers = { "clangd", "tsserver", "pyright", "lua_ls" }
            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end
        end,
    },
}
