-- ┌─────────────────┐
-- │ Colorscheme     │
-- └─────────────────┘

return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- Highest priority to load first
    lazy = false,    -- Load immediately, not lazy
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,          -- Enable transparency (matching your everforest setup)
        dimInactive = false,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          }
        },
        overrides = function(colors)
          return {
            -- Remove diagnostic underlining (matching your everforest setup)
            DiagnosticUnderlineError = { undercurl = false, underline = false },
            DiagnosticUnderlineWarn = { undercurl = false, underline = false },
            DiagnosticUnderlineInfo = { undercurl = false, underline = false },
            DiagnosticUnderlineHint = { undercurl = false, underline = false },
          }
        end,
        theme = "wave",              -- Default dark theme
        background = {
          dark = "wave",             -- Can also try "dragon" for late-night sessions
          light = "lotus"
        },
      })

      -- Set dark mode
      vim.o.background = "dark"

      -- Set as default colorscheme
      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
