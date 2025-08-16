-- ┌─────────────────────────────────┐
-- │ Neovim Configuration Entry Point │
-- └─────────────────────────────────┘

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- ┌───────────────────────┐
-- │ lazy.nvim plugin boot │
-- └───────────────────────┘
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup("plugins", {
  change_detection = { notify = false },
})

-- ┌───────────────────────┐
-- │ Mason & LSP bootstrap │
-- └───────────────────────┘
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright" },
})
require("mason-tool-installer").setup({
  ensure_installed = { "pyright" },
  auto_update = false,
  run_on_start = true,
})

-- ┌─────────────────────────────────────┐
-- │ Conform (Ruff fix+format) + keymap │
-- └─────────────────────────────────────┘
require("conform").setup({
  formatters_by_ft = { python = { "ruff_fix", "ruff_format" } },
  format_on_save = { lsp_fallback = false, timeout_ms = 1500 },
})

-- Setup LSP after everything is loaded
require("lsp").setup()
