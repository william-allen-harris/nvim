-- ┌─────────────────┐
-- │ Colorscheme     │
-- └─────────────────┘

return {
  {
    "sainnhe/everforest",
    priority = 1000, -- Highest priority to load first
    lazy = false,    -- Load immediately, not lazy
    config = function()
      -- Configure Everforest with dark hard variant
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comment = 0
      vim.g.everforest_transparent_background = 1  -- Enable transparency
      vim.g.everforest_current_word = "grey background"
      vim.g.everforest_diagnostic_text_highlight = 0  -- Disable text underlining
      vim.g.everforest_diagnostic_virtual_text = "colored"
      
      -- Set dark mode
      vim.o.background = "dark"
      
      -- Set as default colorscheme
      vim.cmd.colorscheme("everforest")
      
      -- Custom highlight overrides for transparency and diagnostic styling
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "everforest",
        callback = function()
          vim.schedule(function()
            -- Set 10% transparency (alpha = 0.9)
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
            
            -- Remove diagnostic underlining
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = false, underline = false })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = false, underline = false })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = false, underline = false })
            vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false, underline = false })
          end)
        end,
      })

      -- Ensure it's set even after other plugins load
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            vim.cmd.colorscheme("everforest")
          end)
        end,
      })
    end,
  },
}
