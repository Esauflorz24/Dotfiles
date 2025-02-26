return {
    {
        "slugbyte/lackluster.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local lackluster = require("lackluster")
            local color = lackluster.color

            lackluster.setup({
                tweak_background = {
                    normal = color.black,
                },
            })
            vim.cmd.colorscheme("lackluster-hack")
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            local colorizer = require("colorizer")

            colorizer.setup()
        end,
    },
}
