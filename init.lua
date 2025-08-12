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
-- allow switching buffers without saving (keeps changes in memory)
vim.opt.hidden = true

-- ask "Save changes to …?" instead of throwing E37/E162
vim.opt.confirm = true

-- autosave on certain actions (buffer switches, :make, etc.)
vim.opt.autowrite = true
-- or, more aggressive:
-- vim.opt.autowriteall = true
-- Faster CursorHold so floats appear quickly
vim.o.updatetime = 250

-- Clean, informative diagnostics
vim.diagnostic.config({
  -- ✦ inline text under the line (you already had this)
  virtual_text = {
    prefix = "●",
    source = "if_many",
    spacing = 2,
    format = function(d)
      local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code)
      return code and (d.message .. " [" .. code .. "]") or d.message
    end,
  },
  float = { border = "rounded", source = "if_many" },
  underline = true,
  severity_sort = true,
  update_in_insert = false,

  -- ✦ NEW: define diagnostic sign glyphs here (no sign_define)
  signs = {
    -- ASCII-friendly (you can swap to Nerd icons below)
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.HINT]  = "H",
      [vim.diagnostic.severity.INFO]  = "I",
    },
    -- Optional number-column highlighting:
    numhl = {
       [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
       [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
       [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
       [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
     },
  },
})


-- Auto-open a small float for the current line on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
  end,
})
-- Show diagnostics for this line now (manual)
vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
end, { desc = "Line diagnostics" })

-- Toggle inline virtual text on/off (handy when it’s noisy)
local vt_enabled = true
vim.keymap.set("n", "<leader>tv", function()
  vt_enabled = not vt_enabled
  vim.diagnostic.config({ virtual_text = vt_enabled })
  vim.notify("virtual_text = " .. tostring(vt_enabled))
end, { desc = "Toggle diagnostics virtual text" })

-- ---- Autosave: save ~1s after you stop typing ----
-- works in normal/insert; skips special/readonly buffers; only writes if modified
local uv = vim.uv or vim.loop
local autosave_timer
local function autosave_current_buf()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.bo[buf].buftype ~= "" then return end           -- skip NvimTree, help, terminals, etc.
  if vim.bo[buf].readonly or not vim.bo[buf].modifiable then return end
  if vim.bo[buf].filetype == "" then return end          -- unnamed/no file yet
  if vim.api.nvim_buf_get_option(buf, "modified") then
    vim.cmd("silent keepalt keepjumps update")           -- write only if changed & has a filename
  end
end

local function schedule_autosave(ms)
  if autosave_timer then autosave_timer:stop(); autosave_timer:close() end
  autosave_timer = uv.new_timer()
  autosave_timer:start(ms, 0, vim.schedule_wrap(autosave_current_buf))
end

local group = vim.api.nvim_create_augroup("AutoSaveDebounce", { clear = true })
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = group,
  callback = function() schedule_autosave(1000) end,     -- 1000 ms = 1s
})
-- Save immediately when you leave or lose focus (safety net)
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertLeave" }, {
  group = group,
  callback = autosave_current_buf,
})

-- Optional: a toggle
local autosave_enabled = true
vim.keymap.set("n", "<leader>ta", function()
  autosave_enabled = not autosave_enabled
  if autosave_enabled then
    vim.api.nvim_del_augroup_by_name("AutoSaveDebounce")
    group = vim.api.nvim_create_augroup("AutoSaveDebounce", { clear = true })
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      group = group, callback = function() schedule_autosave(1000) end,
    })
    vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertLeave" }, {
      group = group, callback = autosave_current_buf,
    })
    vim.notify("Autosave: ON")
  else
    pcall(vim.api.nvim_del_augroup_by_name, "AutoSaveDebounce")
    vim.notify("Autosave: OFF")
  end
end, { desc = "Toggle autosave" })

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
-- Git signs in the gutter + hunk actions
{
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- ASCII-friendly signs (works even if Nerd Font is flaky)
    signs = {
      add          = { text = "+" },
      change       = { text = "~" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },
    current_line_blame = true,
    current_line_blame_opts = { delay = 500 },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
      end
      -- Navigate hunks
      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Prev hunk")
      -- Stage / reset
      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
      map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
      -- Info / diff
      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n", "<leader>hd", gs.diffthis, "Diff vs index")
      map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff vs last commit")
      map("n", "<leader>ht", gs.toggle_current_line_blame, "Toggle line blame")
      map("n", "<leader>hw", gs.toggle_word_diff, "Toggle word diff")
    end,
  },
},

-- Optional: Fugitive for porcelain (:Git, :Gdiffsplit, :Gblame, etc.)
{
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gblame", "Gclog", "Gbrowse" },
  keys = {
    { "<leader>gs", "<cmd>Git<CR>",         desc = "Git status (fugitive)" },
    { "<leader>gc", "<cmd>Git commit<CR>",  desc = "Git commit" },
    { "<leader>gp", "<cmd>Git push<CR>",    desc = "Git push" },
    { "<leader>gP", "<cmd>Git pull<CR>",    desc = "Git pull" },
  },
},

-- Optional: modern diff UI (open with :DiffviewOpen)
{
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  config = true,
},

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
{ "christoomey/vim-tmux-navigator", lazy = false },
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
local tb_ok, tb = pcall(require, "telescope.builtin")
if tb_ok then
  vim.keymap.set("n", "<leader>gB", tb.git_branches, { desc = "Git branches" })
  vim.keymap.set("n", "<leader>gC", tb.git_commits,  { desc = "Git commits" })
  vim.keymap.set("n", "<leader>gS", tb.git_status,   { desc = "Git status (Telescope)" })
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
-- Use our own maps (plugin has defaults, but we take control)
vim.g.tmux_navigator_no_mappings = 1

local map = function(m, lhs, rhs)
  vim.keymap.set(m, lhs, rhs, { silent = true, noremap = true })
end

-- Normal + Terminal modes (so it works from :terminal too)
map({ "n", "t" }, "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
map({ "n", "t" }, "<C-j>", "<cmd>TmuxNavigateDown<CR>")
map({ "n", "t" }, "<C-k>", "<cmd>TmuxNavigateUp<CR>")
map({ "n", "t" }, "<C-l>", "<cmd>TmuxNavigateRight<CR>")
map({ "n", "t" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>")

