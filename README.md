# Neovim Setup — Commands & Usage Guide

This README documents how to use your Neovim setup as configured in `init.lua`. It includes a top-level quick reference and plugin-specific sections with examples. **All commands and keymaps below reflect the current configuration**—no extra plugins or mappings are assumed.

> **Notation**: `<leader>` is the **Space** key (`vim.g.mapleader = " "`).

---

## TL;DR Cheat Sheet (Most Used)

**Files & Search**

* Toggle file tree: `<leader>e`
* Find files: `<leader>ff`
* Live grep project: `<leader>fg`
* Buffer list: `<leader>fb`
* Help tags: `<leader>fh`

**LSP (per buffer)**

* Go to definition: `gd`  ·  Declaration: `gD`  ·  References: `gr`  ·  Implementation: `gi`
* Hover docs: `K` · Rename symbol: `<leader>rn` · Code action: `<leader>ca`
* Diagnostics: previous `[d` · next `]d` · line popup: `gl` · list: `<leader>fd`

**Git**

* Status (Fugitive): `<leader>gs` · Commit: `<leader>gc` · Push: `<leader>gp` · Pull: `<leader>gP`
* Hunks (Gitsigns): next `]h` · prev `[h` · stage `<leader>hs` · reset `<leader>hr` · preview `<leader>hp`

**Python / Formatting**

* Select Python venv: `<leader>vs` (or `:VenvSelect`)
* Format buffer (Conform → Ruff): `<leader>F`

**Quality of life**

* Toggle autosave: `<leader>ta` (1s idle save; also on focus/leave)
* Toggle inline diagnostics: `<leader>tv`
* Harpoon: add `<leader>a` · menu `<leader>h` · jump `<leader>1..4`
* Tmux splits: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`, previous `<C-\>`

---

## Core Behavior

### Diagnostics (Neovim built-in)

* Inline diagnostics are **enabled** with `●` prefix and show source/code when available.
* A floating window appears on **hover** (`CursorHold`) for the current line.
* **Manual line popup**: `gl`
* **Toggle inline diagnostics**: `<leader>tv`

### Autosave

* Debounced save **\~1s after typing stops** and on `BufLeave`, `FocusLost`, `InsertLeave`.
* Saves only normal, modifiable, named buffers; skips help/term/NvimTree.
* **Toggle**: `<leader>ta` (re-creates/removes autocmd group).

### Completion & Snippets

* Trigger completion: `<C-Space>`
* Confirm selection: `<CR>` (selects current item if none preselected)
* Navigate menu / expand snippets: `<Tab>` forward, `<S-Tab>` backward
* Snippets provided via **LuaSnip** + `friendly-snippets` (loaded lazily).

### Formatting (Conform)

* `python`: runs `ruff_fix` then `ruff_format`.
* **On-save** formatting enabled for Python (`lsp_fallback = false`).
* **Manual**: `<leader>F`.

---

## Plugins & Commands

### File Tree — `nvim-tree`

* **Toggle**: `<leader>e`
* Follows the current file and updates root.
* Width: 36 cols; shows dotfiles; does not hide git-ignored files.

**Useful actions inside tree** (default `nvim-tree` bindings):

* Open: `<CR>` / `o` · Split: `s` · Vsplit: `v` · Tab: `t`
* Create: `a` · Remove: `d` · Rename: `r` · Refresh: `R`

---

### Fuzzy Finder — `telescope.nvim`

* **Find files**: `<leader>ff`
* **Live grep**: `<leader>fg` *(requires `ripgrep`)*
* **Buffers**: `<leader>fb`
* **Help tags**: `<leader>fh`
* **Diagnostics (workspace)**: `<leader>fd`
* **LSP references (current symbol)**: `<leader>fr`
* **Document symbols**: `<leader>fs`

**Git pickers**:

* Branches: `<leader>gB` · Commits: `<leader>gC` · Status: `<leader>gS`

*Tip*: Press `?` inside Telescope pickers to see mappings.

---

### Git — `gitsigns.nvim`

Hunks in sign column with ASCII-friendly marks. Line blame is enabled (500ms delay).

**Navigation**

* Next/Prev hunk: `]h` / `[h`

**Stage/Reset**

* Stage hunk: `<leader>hs`  ·  Reset hunk: `<leader>hr`
* Stage entire buffer: `<leader>hS` · Undo stage: `<leader>hu`

**Info & Diff**

* Preview hunk: `<leader>hp`
* Blame current line (full): `<leader>hb`
* Diff vs index: `<leader>hd`
* Diff vs last commit: `<leader>hD`
* Toggle line blame: `<leader>ht` · Toggle word diff: `<leader>hw`

---

### Git Porcelain — `vim-fugitive`

* Status: `<leader>gs` → opens `:Git` status.
* Commit: `<leader>gc`
* Push: `<leader>gp` · Pull: `<leader>gP`

**Examples**

```vim
:Git add %          " stage current file
:Git commit         " open commit buffer
:Git log --oneline  " quick history
```

---

### Modern Diff UI — `diffview.nvim`

* Open / Close / History:

```vim
:DiffviewOpen
:DiffviewClose
:DiffviewFileHistory
```

*Use this to review large diffs more comfortably than split diffs.*

---

### Treesitter — Syntax, Textobjects, Context

**Core** (`nvim-treesitter`)

* Parsers auto-install; highlighting & indentation enabled.
* Incremental selection: `gnn` (start) · expand `grn` · shrink `grm` · scope `grc`.

**Textobjects** (`nvim-treesitter-textobjects`)

* Select function/class/parameter:

  * `af` / `if` → function outer/inner
  * `ac` / `ic` → class outer/inner
  * `ap` / `ip` → parameter outer/inner
* Motions:

  * Next function/class start: `]m` / `]]`
  * Prev function/class start: `[m` / `[[`

**Sticky Context** (`nvim-treesitter-context`)

* Shows current function/class at the top as you scroll (max 4 lines).

---

### LSP — `mason`, `mason-lspconfig`, `lspconfig`

* **Servers installed**: `pyright` (via Mason + installer).
* **Capabilities**: integrated with `nvim-cmp` for completion.
* **Buffer-local LSP maps** (active when a server attaches):

  * `gd` / `gD` / `gr` / `gi` for goto & references
  * `K` hover · `<leader>rn` rename · `<leader>ca` code actions
  * `[d` / `]d` for diagnostics navigation

> **Ruff LSP**: configured with formatting **disabled** (formatting handled by Conform + Ruff tools). If you have an `on_attach_common` function defined elsewhere, it will also run.

---

### Completion — `nvim-cmp` + Snippets — `LuaSnip`

* Trigger completion: `<C-Space>`
* Confirm: `<CR>`
* Navigate & snippet jump: `<Tab>` / `<S-Tab>`
* Sources: LSP, signature help, snippets, path, buffer.

**Example**

```python
# Type and accept completion with <CR>
from dataclasses import dataclass
@dataclass
class Trade:
    price: float
    qty: int
```

---

### Auto Pairs — `nvim-autopairs`

* Auto-inserts matching `) ] } ' "` and integrates with completion confirmation.

---

### GitHub Copilot — `github/copilot.vim`

* **Accept suggestion**: `<C-l>` (custom mapping; Tab is disabled)
* **First time**: run `:Copilot setup`

*Tip*: Copilot “ghost text” is shown by Copilot itself (CMP ghost text is disabled).

---

### Harpoon — Quick File Marks

* Add file: `<leader>a`
* Menu: `<leader>h`
* Jump to slot 1..4: `<leader>1`, `<leader>2`, `<leader>3`, `<leader>4`

**Example Workflow**

1. Open files you’re toggling between.
2. Add each with `<leader>a`.
3. Use `<leader>1..4` to bounce between them.

---

### Python Venv Selector — `venv-selector.nvim`

* **Select venv**: `<leader>vs` or `:VenvSelect`
* **Cached venv**: `:VenvSelectCached` *(no explicit mapping in this config)*
* Searches common locations (including project `.venv`) and can integrate with Telescope when present.

**Bootstrap helper** — `:UvInit`

```vim
:UvInit
" Creates .venv (if missing) and installs ruff, ruff-lsp, pyright via uv.
```

---

### Tmux Navigator — `vim-tmux-navigator`

* Move between splits/panes: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`
* Previous pane: `<C-\>`

> Works in **normal** and **terminal** modes, so navigation is seamless across Neovim splits and tmux panes.

---

### Colors & UI

* Colorscheme: **Monokai Pro** (variant **spectrum**), terminal colors enabled.
* Signs and diagnostic styles use ASCII-friendly glyphs, suitable without Nerd Fonts.

---

## Tips & Troubleshooting

* **Live Grep requires `ripgrep`** (`rg` in PATH).
* **`venv-selector` search uses `fd`** in the custom command shown in `init.lua`—install `fd` for best results.
* If diagnostics feel noisy, toggle inline virtual text with `<leader>tv` and use `gl` on demand.
* If a file isn’t saving automatically, ensure it’s not read-only and has a filename. Autosave also triggers on buffer leave/focus loss.

---

## Appendix — Command Reference (Flat List)

**Leader**: Space

**General**

* Toggle tree: `<leader>e`
* Toggle autosave: `<leader>ta`
* Toggle inline diagnostics: `<leader>tv`
* Format buffer: `<leader>F`

**Telescope**

* Files `<leader>ff` · Grep `<leader>fg` · Buffers `<leader>fb` · Help `<leader>fh`
* Diagnostics `<leader>fd` · References `<leader>fr` · Symbols `<leader>fs`
* Git: Branches `<leader>gB` · Commits `<leader>gC` · Status `<leader>gS`

**LSP**

* `gd`, `gD`, `gr`, `gi`, `K`, `<leader>rn`, `<leader>ca`, `[d`, `]d`, `gl`

**Git (Gitsigns)**

* `]h`, `[h`, `<leader>hs`, `<leader>hr`, `<leader>hS`, `<leader>hu`, `<leader>hp`, `<leader>hb`, `<leader>hd`, `<leader>hD`, `<leader>ht`, `<leader>hw`

**Fugitive**

* `<leader>gs`, `<leader>gc`, `<leader>gp`, `<leader>gP`

**Diffview**

* `:DiffviewOpen`, `:DiffviewClose`, `:DiffviewFileHistory`

**Harpoon**

* `<leader>a`, `<leader>h`, `<leader>1..4`

**Python**

* Venv select: `<leader>vs` / `:VenvSelect`
* Cached venv: `:VenvSelectCached`
* Bootstrap: `:UvInit`

**Copilot**

* Accept suggestion: `<C-l>`

**Tmux Navigation**

* `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`, `<C-\>`

---

*That’s it. Drop this in your repo alongside `init.lua`. Ping me if you want this split into module files with the same behavior and a generated table of contents.*

