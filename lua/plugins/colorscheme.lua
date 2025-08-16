-- ┌─────────────────┐
-- │ Colorscheme     │
-- └─────────────────┘

return {
  {
    "loctvl842/monokai-pro.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    priority = 1000,
    config = function()
      require("monokai-pro").setup({ filter = "spectrum", terminal_colors = true })
      vim.cmd.colorscheme("monokai-pro")
    end,
  },
}
