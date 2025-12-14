# Neovim Configuration for Python Development

A modern, modular Neovim configuration optimized for Python development with comprehensive LSP support, debugging, testing, and an enhanced UI.

## Directory Structure

```
~/.config/nvim/
├── init.lua                     # Entry point - loads config and lazy.nvim
├── lsp/                         # LSP server configurations (Neovim 0.11+)
│   ├── lua_ls.lua
│   ├── pyright.lua
│   └── ruff.lua
├── lua/
│   ├── config/                  # Core configuration
│   │   ├── options.lua          # Vim options and settings
│   │   ├── keymaps.lua          # Global keymaps
│   │   └── autocmds.lua         # Diagnostics, autosave, autocmds
│   └── plugins/                 # Plugin specifications (lazy.nvim)
│       ├── core.lua             # Core libraries (plenary, devicons, tmux-nav)
│       ├── colorscheme.lua      # Kanagawa theme
│       ├── statusline.lua       # Lualine status bar
│       ├── lsp.lua              # LSP, Mason, Conform, Copilot
│       ├── completion.lua       # nvim-cmp, LuaSnip, autopairs
│       ├── ui.lua               # Telescope, Harpoon, Flash, NvimTree
│       ├── git.lua              # Gitsigns
│       ├── treesitter.lua       # Treesitter + textobjects
│       ├── python.lua           # Python tools (DAP, neotest, iron, venv)
│       ├── workspace.lua        # Sessions, Trouble, Spectre
│       └── snacks.lua           # Snacks.nvim utilities
```

## Features

- **LSP Support**: Pyright (type checking), Ruff (linting/formatting), lua_ls
- **Python Development**: Virtual env management, pytest, debugging, REPL
- **Git Integration**: Gitsigns, Lazygit, Diffview, git commands
- **Navigation**: Telescope, Harpoon, Flash.nvim, NvimTree
- **Completion**: nvim-cmp with LSP, snippets, Copilot
- **Treesitter**: Syntax highlighting, textobjects, context
- **Session Management**: Auto-save, project detection, persistence

---

## Keybindings Reference

**Leader Key: `<Space>`**

### Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h>` | n, t | Navigate left (tmux/vim windows) |
| `<C-j>` | n, t | Navigate down (tmux/vim windows) |
| `<C-k>` | n, t | Navigate up (tmux/vim windows) |
| `<C-l>` | n, t | Navigate right (tmux/vim windows) |
| `<C-\>` | n, t | Navigate to previous pane |
| `<C-d>` | n | Scroll down (centered) |
| `<C-u>` | n | Scroll up (centered) |
| `n` | n | Next search result (centered) |
| `N` | n | Previous search result (centered) |

### Window Management

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>-` | n | Horizontal split |
| `<leader>\|` | n | Vertical split |
| `<C-Up>` | n | Increase window height |
| `<C-Down>` | n | Decrease window height |
| `<C-Left>` | n | Decrease window width |
| `<C-Right>` | n | Increase window width |

### File Operations

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | n | Save file |
| `<leader>W` | n | Save all files |
| `<leader>q` | n | Quit |
| `<leader>Q` | n | Quit all |
| `<leader>e` | n | Toggle NvimTree file explorer |

### Telescope (Find)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fb` | n | Browse buffers |
| `<leader>fh` | n | Help tags |
| `<leader>fd` | n | Diagnostics |
| `<leader>fc` | n | Commands |
| `<leader>fk` | n | Keymaps |
| `<leader>fm` | n | Marks |
| `<leader>fj` | n | Jumplist |
| `<leader>fo` | n | Recent files (oldfiles) |
| `<leader>fr` | n | Resume last search |

### Git Operations

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ga` | n | Git add all |
| `<leader>gm` | n | Git commit (with message prompt) |
| `<leader>gp` | n | Git push |
| `<leader>gv` | n | Git push upstream (set-upstream) |
| `<leader>gu` | n | Git pull |
| `<leader>gF` | n | Git fetch |
| `<leader>gf` | n | Git files (Telescope) |
| `<leader>gs` | n | Git status (Telescope) |
| `<leader>gb` | n | Git branches (Telescope) |
| `<leader>gc` | n | Git commits (Telescope) |
| `<leader>gh` | n | Git stash (Telescope) |
| `<leader>gd` | n | Git diff view (Diffview) |
| `<leader>gD` | n | Close diff view |
| `<leader>gH` | n | File history (Diffview) |
| `<leader>gB` | n | Git browse (open in browser) |
| `<leader>gL` | n | Git blame line (Snacks) |
| `<leader>gg` | n | Lazygit |

### Git Hunks (Gitsigns)

| Key | Mode | Description |
|-----|------|-------------|
| `]c` | n | Next git hunk |
| `[c` | n | Previous git hunk |
| `<leader>hs` | n, v | Stage hunk |
| `<leader>hr` | n, v | Reset hunk |
| `<leader>hS` | n | Stage buffer |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hR` | n | Reset buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line (popup) |
| `<leader>hd` | n | Diff this |
| `<leader>hD` | n | Diff this ~ |
| `<leader>tb` | n | Toggle git blame line |
| `<leader>td` | n | Toggle deleted lines |
| `ih` | o, x | Select git hunk (text object) |

### LSP

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | Find references |
| `gi` | n | Go to implementation |
| `gt` | n | Go to type definition |
| `K` | n | Hover documentation |
| `<leader>rn` | n | Rename symbol |
| `<leader>ca` | n | Code action |
| `<leader>ds` | n | Document symbols |
| `<leader>ws` | n | Workspace symbols |
| `<leader>ic` | n | Incoming calls |
| `<leader>oc` | n | Outgoing calls |
| `<leader>F` | n | Format buffer |

### Diagnostics

| Key | Mode | Description |
|-----|------|-------------|
| `[d` | n | Previous diagnostic |
| `]d` | n | Next diagnostic |
| `<leader>dl` | n | Line diagnostics (float) |
| `gl` | n | Line diagnostics (float) |
| `<leader>tv` | n | Toggle virtual text diagnostics |
| `<leader>xx` | n | Diagnostics (Trouble) |
| `<leader>xX` | n | Buffer diagnostics (Trouble) |
| `<leader>xL` | n | Location list (Trouble) |
| `<leader>xQ` | n | Quickfix list (Trouble) |
| `<leader>cs` | n | Symbols (Trouble) |
| `<leader>cl` | n | LSP definitions/references (Trouble) |

### Harpoon

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>a` | n | Add file to harpoon |
| `<leader>h` | n | Toggle harpoon menu |
| `<leader>1` | n | Harpoon file 1 |
| `<leader>2` | n | Harpoon file 2 |
| `<leader>3` | n | Harpoon file 3 |
| `<leader>4` | n | Harpoon file 4 |
| `<leader>5` | n | Harpoon file 5 |
| `[h` | n | Previous harpoon file |
| `]h` | n | Next harpoon file |

### Flash Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash treesitter |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `<C-s>` | c | Toggle flash search |

### Buffer Management (Snacks)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>bd` | n | Delete buffer |
| `<leader>bD` | n | Delete all buffers |
| `<leader>bo` | n | Delete other buffers |

### Python Development

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>vs` | n | Select Python venv |
| `<leader>vc` | n | Activate cached venv |

### Python Testing (Neotest)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tt` | n | Run nearest test |
| `<leader>tf` | n | Run file tests |
| `<leader>td` | n | Debug nearest test |
| `<leader>ts` | n | Toggle test summary |
| `<leader>to` | n | Show test output |
| `<leader>tO` | n | Toggle test output panel |
| `<leader>tr` | n | Run last test |
| `<leader>ta` | n | Run all tests |
| `<leader>tS` | n | Stop tests |

### Python REPL (Iron)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>rs` | n | Start REPL |
| `<leader>rr` | n | Restart REPL |
| `<leader>rf` | n | Focus REPL |
| `<leader>rh` | n | Hide REPL |
| `<space>sc` | n, v | Send motion/selection to REPL |
| `<space>sf` | n | Send file to REPL |
| `<space>sl` | n | Send line to REPL |

### Python Docstrings (Neogen)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>nf` | n | Generate function docstring |
| `<leader>nc` | n | Generate class docstring |
| `<leader>nt` | n | Generate type docstring |

### Debugging (DAP)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>db` | n | Toggle breakpoint |
| `<leader>dB` | n | Breakpoint with condition |
| `<leader>dc` | n | Continue |
| `<leader>dC` | n | Run to cursor |
| `<leader>di` | n | Step into |
| `<leader>do` | n | Step out |
| `<leader>dO` | n | Step over |
| `<leader>dp` | n | Pause |
| `<leader>dt` | n | Terminate |
| `<leader>dr` | n | Toggle REPL |
| `<leader>dL` | n | Run last |
| `<leader>dS` | n | Session |
| `<leader>dg` | n | Go to line (no execute) |
| `<leader>dj` | n | Down (stack frame) |
| `<leader>dk` | n | Up (stack frame) |
| `<leader>dw` | n | Widgets |
| `<leader>du` | n | Toggle DAP UI |
| `<leader>de` | n, v | Eval expression |

### Treesitter Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `]m` | n | Next function start |
| `[m` | n | Previous function start |
| `]M` | n | Next function end |
| `[M` | n | Previous function end |
| `]]` | n | Next class start |
| `[[` | n | Previous class start |
| `][` | n | Next class end |
| `[]` | n | Previous class end |
| `]a` | n | Next parameter |
| `[a` | n | Previous parameter |
| `]o` | n | Next loop |
| `[o` | n | Previous loop |
| `]s` | n | Next statement |
| `[s` | n | Previous statement |
| `]/` | n | Next comment |
| `[/` | n | Previous comment |
| `]z` | n | Next fold |
| `[z` | n | Previous fold |

### Treesitter Text Objects

| Key | Mode | Description |
|-----|------|-------------|
| `af` | v, o | Around function |
| `if` | v, o | Inside function |
| `ac` | v, o | Around class |
| `ic` | v, o | Inside class |
| `ap` | v, o | Around parameter |
| `ip` | v, o | Inside parameter |

### Treesitter Selection

| Key | Mode | Description |
|-----|------|-------------|
| `gnn` | n | Init selection |
| `grn` | n | Increment node selection |
| `grm` | n | Decrement node selection |
| `grc` | n | Increment scope selection |

### Reference Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `]r` | n | Next reference (illuminate) |
| `[r` | n | Previous reference (illuminate) |
| `]w` | n | Next word reference (Snacks) |
| `[w` | n | Previous word reference (Snacks) |

### Session Management

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>qs` | n | Restore session |
| `<leader>ql` | n | Restore last session |
| `<leader>qd` | n | Don't save current session |

### Snacks Utilities

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>un` | n | Dismiss notifications |
| `<leader>nh` | n | Notification history |
| `<C-/>` | n, t | Toggle terminal |
| `<leader>z` | n | Toggle zen mode |
| `<leader>Z` | n | Toggle zoom |
| `<leader>.` | n | Toggle scratch buffer |
| `<leader>S` | n | Select scratch buffer |
| `<leader>cR` | n | Rename file |

### UI Toggles (Snacks)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>us` | n | Toggle spelling |
| `<leader>uw` | n | Toggle wrap |
| `<leader>uL` | n | Toggle relative number |
| `<leader>ud` | n | Toggle diagnostics |
| `<leader>ul` | n | Toggle line number |
| `<leader>uT` | n | Toggle treesitter |
| `<leader>uh` | n | Toggle inlay hints |
| `<leader>ug` | n | Toggle indent guides |
| `<leader>uD` | n | Toggle dim |
| `<leader>ut` | n | Toggle colorscheme (Kanagawa/Monokai) |
| `<leader>uT` | n | Open theme picker (Themery) |

### Search & Replace

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sr` | n | Search and replace in files (Spectre) |

### Editing Helpers

| Key | Mode | Description |
|-----|------|-------------|
| `jk` | i | Escape |
| `kj` | i | Escape |
| `<Esc>` | n | Clear search highlight |
| `<` | v | Indent left (stay in visual) |
| `>` | v | Indent right (stay in visual) |
| `<A-j>` | n | Move line down |
| `<A-k>` | n | Move line up |
| `<A-j>` | v | Move selection down |
| `<A-k>` | v | Move selection up |
| `p` | v | Paste without yanking |

### Completion (Insert Mode)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-Space>` | i | Trigger completion |
| `<CR>` | i | Confirm completion |
| `<Tab>` | i, s | Next completion / expand snippet |
| `<S-Tab>` | i, s | Previous completion / jump back |
| `<C-b>` | i | Scroll docs up |
| `<C-f>` | i | Scroll docs down |
| `<C-e>` | i | Abort completion |
| `<C-l>` | i | Accept Copilot suggestion |

### Autosave

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>as` | n | Toggle autosave |

---

## Commands

| Command | Description |
|---------|-------------|
| `:Mason` | Open Mason package manager |
| `:Lazy` | Open lazy.nvim plugin manager |
| `:UvInit` | Bootstrap Python project with uv |
| `:ConformInfo` | Show formatter information |
| `:Trouble` | Open trouble diagnostics |
| `:Spectre` | Open search and replace |
| `:DiffviewOpen` | Open git diff view |
| `:DiffviewClose` | Close git diff view |
| `:IronRepl` | Start Python REPL |
| `:VenvSelect` | Select Python virtual environment |

---

## Installation

1. **Backup existing config**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone/copy this config** to `~/.config/nvim`

3. **Install dependencies**:
   ```bash
   # Python tools
   pip install ruff pyright debugpy

   # System tools (for Telescope, venv-selector)
   # macOS: brew install fd ripgrep
   # Ubuntu: sudo apt install fd-find ripgrep
   ```

4. **First run**: Open Neovim and let lazy.nvim install plugins

5. **Python setup**: Use `:UvInit` or `:VenvSelect` for environment management

## Customization

- `lua/config/options.lua` - Vim settings
- `lua/config/keymaps.lua` - Global keybindings
- `lua/config/autocmds.lua` - Autocommands and diagnostics
- `lua/plugins/*.lua` - Plugin configurations
- `lsp/*.lua` - LSP server configurations
