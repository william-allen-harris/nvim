# 🚀 Comprehensive Neovim Configuration for Python Development

A modern, modular Neovim configuration optimized for Python development with a comprehensive status bar and enhanced UI.

## 📁 Directory Structure

```
~/.config/nvim/
├── init.lua                     # Entry point
├── init.lua.backup             # Original config backup
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── options.lua         # Vim options and settings
│   │   ├── keymaps.lua         # Global keymaps
│   │   └── autocmds.lua        # Diagnostics, autocmds, and commands
│   ├── lsp/                    # LSP configuration
│   │   └── init.lua            # LSP setup and keymaps
│   └── plugins/                # Plugin specifications
│       ├── core.lua            # Core libraries
│       ├── colorscheme.lua     # Monokai Pro theme
│       ├── statusline.lua      # Status line & buffer line
│       ├── lsp.lua             # LSP tools (Mason, Conform, etc.)
│       ├── ui.lua              # UI plugins (Telescope, Harpoon, etc.)
│       ├── git.lua             # Git integration
│       ├── treesitter.lua      # Syntax highlighting
│       ├── completion.lua      # Completion stack
│       ├── python.lua          # Python-specific tools
│       └── workspace.lua       # Session & workspace management
```

## ✨ Features

### 📊 Comprehensive Status Line & Tab Line
- **File Information**: Name, type, size, encoding, line endings
- **Python Environment**: Current virtual environment with 🐍 icon
- **Git Integration**: Branch, diff stats, blame information
- **LSP Status**: Active language servers and diagnostics count
- **System Info**: Time, location, progress, macro recording
- **Enhanced Buffer Line**: With diagnostics, close buttons, and visual indicators

### 🐍 Python Development
- **Environment Management**: Automatic virtual environment detection and switching
- **LSP Support**: Pyright for type checking, Ruff for linting and formatting
- **Test Runner**: Integrated pytest support with neotest
- **REPL Integration**: Interactive Python REPL with Iron.nvim
- **Docstring Generation**: Automatic Google-style docstrings with neogen
- **PEP8 Indentation**: Proper Python indentation support

### 🔧 Development Tools
- **File Explorer**: nvim-tree with git integration
- **Fuzzy Finding**: Telescope for files, grep, symbols, diagnostics
- **Quick Navigation**: Harpoon for project file bookmarks
- **Git Integration**: Gitsigns, Fugitive, and Diffview
- **Session Management**: Automatic session persistence
- **Project Management**: Automatic project detection
- **Workspace Diagnostics**: Trouble.nvim for enhanced error display

### ⚡ Enhanced UI
- **Modern Theme**: Monokai Pro with terminal colors
- **Smart Completion**: nvim-cmp with LSP, snippets, and paths
- **Syntax Highlighting**: Treesitter with textobjects
- **Auto-pairs**: Intelligent bracket/quote pairing
- **Tmux Integration**: Seamless pane navigation

## 🚀 Key Bindings

### Leader Key: `<Space>`

#### File Operations
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Browse buffers
- `<leader>fh` - Help tags
- `<leader>fd` - Diagnostics
- `<leader>fc` - Commands
- `<leader>fk` - Keymaps
- `<leader>fm` - Marks
- `<leader>fj` - Jump list
- `<leader>fo` - Old files
- `<leader>e` - Toggle file tree

#### Git Operations
- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push
- `<leader>gP` - Git pull
- `<leader>gB` - Git branches
- `<leader>gC` - Git commits
- `<leader>gS` - Git status (Telescope)
- `<leader>gf` - Git files
- `<leader>gb` - Toggle git blame virtual text (gitsigns)
- `<leader>hb` - Show blame line (popup)
- `<leader>ht` - Toggle gitsigns line blame
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `]h` / `[h` - Next/Previous hunk

#### Python Development
- `<leader>vs` - Select Python virtual environment
- `<leader>vc` - Activate cached virtual environment
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>td` - Debug nearest test
- `<leader>ts` - Toggle test summary
- `<leader>to` - Show test output
- `<leader>tO` - Toggle test output panel
- `<leader>tr` - Run last test
- `<leader>ta` - Run all tests
- `<leader>tS` - Stop tests
- `<leader>nf` - Generate function docstring
- `<leader>nc` - Generate class docstring
- `<leader>rs` - Start Python REPL
- `<leader>rr` - Restart REPL

#### Buffer Management
- `<Tab>` / `<S-Tab>` - Next/Previous buffer (easy cycling)
- `]b` / `[b` - Next/Previous buffer (bracket style)
- `<S-h>` / `<S-l>` - Next/Previous buffer (vim-style)
- `<leader>bn` / `<leader>bp` - Next/Previous buffer (explicit)
- `<leader>fb` - Browse all buffers (Telescope)
- `<leader>bd` - Delete buffer (smart - goes to next)
- `<leader>bx` - Delete buffer (default)
- `<leader>bD` - Force delete buffer
- `<leader>bp` - Toggle buffer pin
- `<leader>bo` - Delete other buffers
- `<Alt-1>` to `<Alt-9>` - Jump to buffer by number

#### LSP & Diagnostics
- `gd` - Go to definition (Telescope)
- `gD` - Go to declaration
- `gr` - Find references (Telescope)
- `gi` - Go to implementation (Telescope)
- `gt` - Go to type definition (Telescope)
- `<leader>ds` - Document symbols (Telescope)
- `<leader>ws` - Workspace symbols (Telescope)
- `<leader>ic` - Incoming calls (Telescope)
- `<leader>oc` - Outgoing calls (Telescope)
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `[d]` / `]d` - Previous/Next diagnostic
- `gl` - Show line diagnostics
- `<leader>F` - Format buffer

#### Toggles
- `<leader>tv` - Toggle virtual text diagnostics (starts disabled)
- `<leader>ta` - Toggle autosave
- `<leader>gb` - Toggle git blame virtual text (gitsigns)
- `<leader>ht` - Toggle gitsigns line blame

#### Workspace
- `<leader>xx` - Toggle diagnostics (Trouble)
- `<leader>xX` - Buffer diagnostics (Trouble)
- `<leader>sr` - Search and replace in files
- `<leader>qs` - Restore session
- `<leader>ql` - Restore last session

#### Harpoon Quick Navigation
- `<leader>a` - Add file to harpoon
- `<leader>h` - Toggle harpoon menu
- `<leader>1-4` - Navigate to harpoon files 1-4

#### Buffer Tab Navigation
- `<leader>b1-9` - Jump to buffer by tab number (matches displayed numbers)
- `<Alt-1>` to `<Alt-9>` - Alternative buffer jumping by number

#### Function & Class Navigation (Treesitter)
- `]m` / `[m` - Next/Previous function start
- `]M` / `[M` - Next/Previous function end
- `]]` / `[[` - Next/Previous class start  
- `][` / `[]` - Next/Previous class end
- `]c` / `[c` - Next/Previous comment
- `]s` / `[s` - Next/Previous statement
- `]o` / `[o` - Next/Previous loop
- `]a` / `[a` - Next/Previous parameter
- `]z` / `[z` - Next/Previous fold

#### Text Objects (Select/Delete/Change)
- `af` / `if` - Around/Inside function
- `ac` / `ic` - Around/Inside class
- `ap` / `ip` - Around/Inside parameter

## 🎨 Status Line Components

### Left Section
- **Mode**: Current Vim mode (single character)
- **Macro Recording**: Shows when recording macros
- **Git Branch**: Current branch with git icon
- **Git Diff**: Added/modified/removed line counts

### Center Section
- **Filename**: Relative path with modification indicators
- **File Type**: With colored icons
- **File Size**: Human-readable file size

### Right Section
- **Python Environment**: 🐍 Active virtual environment
- **LSP Status**: Active language servers
- **Diagnostics**: Error/warning/hint/info counts
- **Encoding**: File encoding (UTF-8, etc.)
- **Line Endings**: LF, CRLF, or CR
- **Location**: Line and column numbers
- **Progress**: Percentage through file
- **Time**: Current time (HH:MM)

## 🛠️ Installation & Setup

1. **Backup your existing config**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **This config is already installed** - it was refactored from your existing setup

3. **Install dependencies** (if needed):
   ```bash
   # For Python development
   pip install ruff pyright

   # For fd (used by telescope and venv-selector)
   # Ubuntu/Debian: sudo apt install fd-find
   # Arch: sudo pacman -S fd
   # macOS: brew install fd
   ```

4. **First run**: Open Neovim and let lazy.nvim install all plugins

5. **Python environment setup**: Use `:UvInit` to bootstrap a project with uv

## 🎯 Python Development Workflow

1. **Open your Python project**: `nvim your_project/`
2. **Select environment**: `<leader>vs` to choose your virtual environment
3. **Navigate files**: `<leader>ff` to find files, `<leader>fg` to grep
4. **Add to harpoon**: `<leader>a` to bookmark important files
5. **Run tests**: `<leader>tt` for nearest test, `<leader>tf` for file tests
6. **Start REPL**: `<leader>rs` for interactive Python development
7. **Generate docs**: `<leader>nf` for function docstrings
8. **Git workflow**: `<leader>gs` for status, stage hunks with `<leader>hs`

The status line will show all relevant information: your active Python environment, git branch, LSP status, and diagnostics - everything you need for productive Python development!

## 🔧 Customization

All configuration is modular and easy to customize:
- Modify `lua/config/options.lua` for Vim settings
- Update `lua/config/keymaps.lua` for key bindings
- Edit plugin files in `lua/plugins/` to add/remove features
- Customize the status line in `lua/plugins/statusline.lua`

Enjoy your enhanced Neovim experience! 🎉
