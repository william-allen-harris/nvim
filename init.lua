-- Minimal, sensible defaults
vim.opt.number = true               -- line numbers
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"   -- uses wl-clipboard/xclip
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.keymap.set("n", "<space>", "<nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- --- Plugins via lazy.nvim ---
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
-- Ruff format/fix orchestrator
  { "stevearc/conform.nvim" },
-- GitHub Copilot
  { "github/copilot.vim" },
-- Harpoon (quick file marking/jumping)
  { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },
-- Optional: venv picker (works great with uv-created .venv)
  { "linux-cultist/venv-selector.nvim", branch = "regexp", dependencies = { "neovim/nvim-lspconfig" } },
-- Optional: ensure tools auto-install via Mason
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
-- Monokai Pro colorscheme
{
  "loctvl842/monokai-pro.nvim",
  dependencies = { "MunifTanjim/nui.nvim" }, -- for :MonokaiProSelect menu
  priority = 1000,                            -- load early
  config = function()
    require("monokai-pro").setup({
      filter = "spectrum",                    -- options: pro, classic, machine, octagon, ristretto, spectrum
      terminal_colors = true,
    })
    vim.cmd.colorscheme("monokai-pro")
  end,
},
-- File icons
{ "nvim-tree/nvim-web-devicons", lazy = true },

-- File tree
{
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- disable netrw (recommended by nvim-tree)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      view = { width = 36 },
      renderer = { group_empty = true },
      filters = { dotfiles = false, git_ignored = false },
      update_focused_file = { enable = true, update_root = true },
    })

    -- Toggle key
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File tree" })
  end,
},  
-- Treesitter core
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      -- core
      "lua", "vim", "vimdoc", "regex", "bash",
      -- data / configs
      "json", "jsonc", "yaml", "toml",
      -- docs
      "markdown", "markdown_inline",
      -- dev focus
      "python", "dockerfile", "gitcommit",
    },
    auto_install = true, -- download missing parsers on open
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",        -- start selection
        node_incremental = "grn",      -- expand to next node
        node_decremental = "grm",      -- shrink
        scope_incremental = "grc",     -- expand to scope
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
},

-- Textobjects (select funcs/classes/params, jump between them)
{
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer", ["if"] = "@function.inner",
          ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
          ["ap"] = "@parameter.outer",["ip"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start =   { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
        goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
},

-- Sticky context (shows the current function/class at the top as you scroll)
{
  "nvim-treesitter/nvim-treesitter-context",
  opts = { enable = true, max_lines = 4, mode = "cursor" },
},
-- Snippets
{ "L3MON4D3/LuaSnip", build = "make install_jsregexp", dependencies = { "rafamadriz/friendly-snippets" } },

-- Completion core + sources
{ "hrsh7th/nvim-cmp" },
{ "hrsh7th/cmp-nvim-lsp" },
{ "saadparwaiz1/cmp_luasnip" },
{ "hrsh7th/cmp-path" },
{ "hrsh7th/cmp-buffer" },
{ "hrsh7th/cmp-nvim-lsp-signature-help" }, -- live parameter hints in the menu

-- Optional: auto-insert matching ) ] } and integrate with completion confirm
{ "windwp/nvim-autopairs" },
})

-- Basic post-setup
require("mason").setup()
require("mason-lspconfig").setup({
   ensure_installed = {"pyright"},
})
require("lspconfig").pyright.setup({})  -- example: Python LSP if you have it
-- ---------- MASON: auto-install toolchain ----------
require("mason-tool-installer").setup({
  ensure_installed = {
    "pyright",      -- Python LSP
    },
  auto_update = false,
  run_on_start = true,
})

-- ---------- LSP: Pyright + Ruff LSP ----------
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.pyright.setup({})

-- ---------- CONFORM: Ruff fix + format on save ----------
-- Requires ruff binary; we installed with Mason (or via uv in your .venv)
require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format" },  -- run fixers then formatter
  },
  format_on_save = {
    lsp_fallback = false,
    timeout_ms = 1500,
  },
})
vim.keymap.set("n", "<leader>F", function()
  require("conform").format({ async = true })
end, { desc = "Format buffer (Conform)" })

-- ---------- COPILOT ----------
-- Disable default <Tab> mapping, add a clean accept key
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true, replace_keycodes = false })
-- Run :Copilot setup to sign in the first time

-- ---------- HARPOON ----------
-- v1 API (stable)
local harpoon_mark = require("harpoon.mark")
local harpoon_ui   = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", harpoon_mark.add_file, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>h", harpoon_ui.toggle_quick_menu, { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>1", function() harpoon_ui.nav_file(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon_ui.nav_file(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon_ui.nav_file(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon_ui.nav_file(4) end, { desc = "Harpoon file 4" })

-- ---------- VENV SELECTOR (uv-friendly) ----------
-- If you use uv with a project-local .venv, this makes switching trivial
require("venv-selector").setup({
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  dependencies = {
    "neovim/nvim-lspconfig",
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
    { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Activate cached venv" },
  },
  opts = {
    options = {
      enable_default_searches = true,      -- keep built-ins
      enable_cached_venvs = true,
      cached_venv_automatic_activation = true,
      -- require_lsp_activation = false,   -- set to false if you want to pick before opening a .py
    },
    -- Ensure we also search the current project (incl. hidden dirs like .venv)
    search = {
      cwd = { command = "fd '/bin/python$' $CWD --full-path --color never -E /proc -I -a -L" },
    },
  },
})
vim.keymap.set("n", "<leader>vs", ":VenvSelect<CR>", { desc = "Select Python venv" })

-- ---------- Helper: project bootstrap via uv (optional) ----------
-- Run :UvInit in a Python project to create .venv and install dev tooling in it
vim.api.nvim_create_user_command("UvInit", function()
  local has_uv = vim.fn.executable("uv") == 1
  if not has_uv then
    vim.notify("uv not found. Install from https://docs.astral.sh/uv/ first.", vim.log.levels.ERROR)
    return
  end
  -- Create a .venv if missing, then add ruff, ruff-lsp, pyright to it
  local cmd = [[bash -lc 'set -euo pipefail; uv venv --python 3 || true; source .venv/bin/activate && uv pip install -U ruff ruff-lsp pyright']]
  vim.fn.jobstart(cmd, { cwd = vim.fn.getcwd(), detach = true })
  vim.notify("Bootstrapping .venv with ruff, ruff-lsp, pyright via uv…", vim.log.levels.INFO)
end, {})
-- ===== Telescope keymaps =====
local ok_telescope, telescope = pcall(require, "telescope.builtin")
if ok_telescope then
  local map = vim.keymap.set
  local opts = { silent = true, noremap = true }

  map("n", "<leader>ff", telescope.find_files, opts)       -- files
  map("n", "<leader>fg", telescope.live_grep, opts)        -- grep project
  map("n", "<leader>fb", telescope.buffers, opts)          -- buffers
  map("n", "<leader>fh", telescope.help_tags, opts)        -- help
  map("n", "<leader>fd", telescope.diagnostics, opts)      -- diagnostics
  map("n", "<leader>fr", telescope.lsp_references, opts)   -- references
  map("n", "<leader>fs", telescope.lsp_document_symbols, opts) -- symbols in file
end

-- ===== LSP quality-of-life =====
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Implementation")
  map("n", "K",  vim.lsp.buf.hover, "Hover docs")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
end

-- Attach these maps to servers we set up:
local lspconfig = require("lspconfig")
-- Reconfigure ruff + pyright to use on_attach
lspconfig.ruff.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    if on_attach_common then on_attach_common(client, bufnr) end
  end,
})
-- Better completion popup behavior
vim.opt.completeopt = "menu,menuone,noselect"

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()  -- loads friendly-snippets

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),                 -- manually trigger
    ["<CR>"] = cmp.mapping.confirm({ select = true }),      -- confirm selection
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },  -- shows function params as you type
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  }),
  experimental = { ghost_text = false },   -- Copilot provides ghost text
})

-- Autopairs (+ cmp integration)
require("nvim-autopairs").setup({})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })

