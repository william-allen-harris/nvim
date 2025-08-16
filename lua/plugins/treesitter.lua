-- ┌─────────────────────┐
-- │ Treesitter & syntax │
-- └─────────────────────┘

return {
  -- Treesitter core
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "regex", "bash",
        "json", "jsonc", "yaml", "toml",
        "markdown", "markdown_inline",
        "python", "dockerfile", "gitcommit",
      },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          node_decremental = "grm",
          scope_incremental = "grc",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Treesitter textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      textobjects = {
        select = {
          enable = true, lookahead = true,
          keymaps = {
            ["af"] = "@function.outer", ["if"] = "@function.inner",
            ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
            ["ap"] = "@parameter.outer",["ip"] = "@parameter.inner",
          },
        },
        move = {
          enable = true, set_jumps = true,
          goto_next_start     = { 
            ["]m"] = "@function.outer", 
            ["]]"] = "@class.outer",
            ["]a"] = "@parameter.outer",
            ["]o"] = "@loop.outer",
            ["]s"] = "@statement.outer",
            ["]z"] = "@fold",
            ["]c"] = "@comment.outer",
          },
          goto_previous_start = { 
            ["[m"] = "@function.outer", 
            ["[["] = "@class.outer",
            ["[a"] = "@parameter.outer", 
            ["[o"] = "@loop.outer",
            ["[s"] = "@statement.outer",
            ["[z"] = "@fold",
            ["[c"] = "@comment.outer",
          },
          goto_next_end     = { 
            ["]M"] = "@function.outer", 
            ["]["] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]O"] = "@loop.outer",
          },
          goto_previous_end = { 
            ["[M"] = "@function.outer", 
            ["[]"] = "@class.outer",
            ["[A"] = "@parameter.outer", 
            ["[O"] = "@loop.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Treesitter context
  { 
    "nvim-treesitter/nvim-treesitter-context", 
    opts = { enable = true, max_lines = 4, mode = "cursor" } 
  },
}
