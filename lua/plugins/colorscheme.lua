-- ┌─────────────────┐
-- │ Colorscheme     │
-- └─────────────────┘

return {
  {
    "loctvl842/monokai-pro.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    priority = 1000, -- Highest priority to load first
    lazy = false,    -- Load immediately, not lazy
    config = function()
      -- Configure Monokai Pro with spectrum filter and terminal colors
      require("monokai-pro").setup({ 
        filter = "spectrum", 
        terminal_colors = true,
        devicons = true, -- Enable devicons integration
        styles = {
          comment = { italic = true },
          keyword = { italic = false },
          type = { italic = false },
          storageclass = { italic = false },
          structure = { italic = false },
          parameter = { italic = false },
          annotation = { italic = false },
          tag_attribute = { italic = false },
        },
      })
      
      -- Set as default colorscheme
      vim.cmd.colorscheme("monokai-pro")
      
      -- Ensure it's set even after other plugins load
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            vim.cmd.colorscheme("monokai-pro")
          end)
        end,
      })
    end,
  },
}
