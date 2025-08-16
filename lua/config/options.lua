-- ┌───────────────────────────┐
-- │ Core options & QoL tweaks │
-- └───────────────────────────┘

local opt = vim.opt

-- General
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"       -- system clipboard (wl-clipboard/xclip)
opt.ignorecase = true
opt.smartcase = true
opt.wrap = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.hidden = true                    -- switch buffers w/o saving
opt.confirm = true                   -- prompt instead of E37/E162
opt.autowrite = true                 -- autosave on certain actions
vim.o.updatetime = 250               -- faster CursorHold

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Leader key
vim.keymap.set("n", "<space>", "<nop>", { silent = true, remap = false })
vim.g.mapleader = " "
