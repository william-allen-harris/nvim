-- ┌─────────────────────┐
-- │ Treesitter & syntax │
-- └─────────────────────┘

return {
  -- Treesitter core (pinned to last stable version with old API)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "regex", "bash",
        "json", "jsonc", "yaml", "toml",
        "markdown", "markdown_inline",
        "python", "dockerfile", "gitcommit",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Treesitter context
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { enable = true, max_lines = 4, mode = "cursor" },
  },
}
