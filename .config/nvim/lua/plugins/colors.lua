return {
  "bluz71/vim-moonfly-colors",
  lazy = false,
  priority = 1000,
  name = "moonfly",

  config = function()
    vim.cmd.colorscheme("moonfly")
  end,
}
