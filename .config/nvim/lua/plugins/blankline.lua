return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
        indent = { char = "│" },
        scope = { enabled = false },
    },
    config = function()
        require("ibl").setup({})
    end,
}
