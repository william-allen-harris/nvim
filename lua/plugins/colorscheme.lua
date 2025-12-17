-- ┌─────────────────┐
-- │ Colorscheme     │
-- └─────────────────┘

return {
  -- Kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(_)
          return {
            DiagnosticUnderlineError = { undercurl = false, underline = false },
            DiagnosticUnderlineWarn = { undercurl = false, underline = false },
            DiagnosticUnderlineInfo = { undercurl = false, underline = false },
            DiagnosticUnderlineHint = { undercurl = false, underline = false },
          }
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
    end,
  },

  -- Oasis (desert-inspired themes)
  {
    "uhs-robert/oasis.nvim",
    lazy = true,
    config = function()
      require("oasis").setup({
        style = "lagoon",
        transparent = true,
        terminal_colors = true,
        styles = {
          bold = true,
          italic = true,
          underline = true,
          undercurl = true,
          strikethrough = true,
        },
      })
    end,
  },

  -- Monokai Pro (default)
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        devicons = true,
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
          type = { italic = true },
        },
        inc_search = "background",
        background_clear = {
          "nvim-tree",
          "neo-tree",
          "bufferline",
          "telescope",
          "toggleterm",
        },
        override = function()
          return {
            DiagnosticUnderlineError = { undercurl = false, underline = false },
            DiagnosticUnderlineWarn = { undercurl = false, underline = false },
            DiagnosticUnderlineInfo = { undercurl = false, underline = false },
            DiagnosticUnderlineHint = { undercurl = false, underline = false },
            -- Subtle indent guides
            SnacksIndent = { fg = "#3b3b3b" },
            SnacksIndentScope = { fg = "#505050" },
            IblIndent = { fg = "#3b3b3b" },
            IblScope = { fg = "#505050" },
            -- Snacks dim/zen mode - just dim the text
            SnacksDim = { fg = "#5b595c" },
            -- Spell: underline instead of red highlight
            SpellBad = { sp = "#fc9867", undercurl = true, bg = "NONE", fg = "NONE" },
            SpellCap = { sp = "#78dce8", undercurl = true, bg = "NONE", fg = "NONE" },
            SpellLocal = { sp = "#a9dc76", undercurl = true, bg = "NONE", fg = "NONE" },
            SpellRare = { sp = "#ab9df2", undercurl = true, bg = "NONE", fg = "NONE" },
          }
        end,
      })

      vim.cmd.colorscheme("monokai-pro")
    end,
  },

  -- Colorscheme toggler
  {
    "zaldih/themery.nvim",
    lazy = true,
    cmd = "Themery",
    keys = {
      {
        "<leader>ut",
        function()
          -- Quick toggle between kanagawa and monokai-pro
          local current = vim.g.colors_name
          if current and current:match("monokai") then
            vim.cmd.colorscheme("kanagawa")
            vim.notify("Switched to Kanagawa", vim.log.levels.INFO)
          else
            -- Ensure monokai-pro is loaded
            require("lazy").load({ plugins = { "monokai-pro.nvim" } })
            vim.cmd.colorscheme("monokai-pro")
            vim.notify("Switched to Monokai Pro", vim.log.levels.INFO)
          end
        end,
        desc = "Toggle colorscheme (Kanagawa/Monokai)",
      },
      {
        "<leader>uC",
        "<cmd>Themery<cr>",
        desc = "Open theme picker",
      },
    },
    opts = {
      themes = {
        { name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
        { name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
        { name = "Kanagawa Lotus", colorscheme = "kanagawa-lotus" },
        { name = "Monokai Pro", colorscheme = "monokai-pro" },
        { name = "Monokai Classic", colorscheme = "monokai-pro-classic" },
        { name = "Monokai Octagon", colorscheme = "monokai-pro-octagon" },
        { name = "Monokai Machine", colorscheme = "monokai-pro-machine" },
        { name = "Monokai Ristretto", colorscheme = "monokai-pro-ristretto" },
        { name = "Monokai Spectrum", colorscheme = "monokai-pro-spectrum" },
        { name = "Oasis Lagoon", colorscheme = "oasis-lagoon" },
        { name = "Oasis Night", colorscheme = "oasis-night" },
        { name = "Oasis Desert", colorscheme = "oasis-desert" },
        { name = "Oasis Canyon", colorscheme = "oasis-canyon" },
        { name = "Oasis Dune", colorscheme = "oasis-dune" },
        { name = "Oasis Mirage", colorscheme = "oasis-mirage" },
        { name = "Oasis Twilight", colorscheme = "oasis-twilight" },
        { name = "Oasis Rose", colorscheme = "oasis-rose" },
      },
      livePreview = true,
    },
  },
}
