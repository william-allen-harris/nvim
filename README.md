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
- `<leader>ghb` - Show blame line (popup)
- `<leader>ght` - Toggle gitsigns line blame
- `<leader>gha` - Stage hunk
- `<leader>ghr` - Reset hunk
- `<leader>ghp` - Preview hunk
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
- `<leader>ght` - Toggle gitsigns line blame

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

## 🎨 Status Line & Toolbar Components

Your Neovim statusline provides comprehensive information at a glance. Here's a detailed breakdown of every component:

### 📊 Buffer Line (Top Tab Bar)

The enhanced buffer line shows all open buffers as tabs with the following features:

- **File Icons**: Colored file type icons for easy identification
- **File Names**: Truncated to fit, with full names on hover
- **Modified Indicators**: Orange dot (●) for unsaved files
- **Close Buttons**: Hover to reveal close buttons for each buffer
- **Diagnostics**: Error/warning/hint counts with colored icons:
  - 󰅚 Red for errors
  - 󰀪 Orange for warnings  
  - 󰌶 Blue for hints
- **Git Integration**: Different styling for git-tracked files
- **Smart Filtering**: Hides help and quickfix buffers automatically

### 📋 Status Line Sections

#### Left Section (lualine_a & lualine_b)

**Mode Indicator**
- 󰰓 **NORMAL**: Normal mode (navigation and commands)
- 󰰅 **INSERT**: Insert mode (typing text)
- 󰰤 **VISUAL**: Visual selection modes (V-LINE, V-BLOCK)
- 󰰞 **COMMAND**: Command-line mode
- 󰰟 **REPLACE/SELECT**: Replace or select modes
- 󰰬 **TERMINAL**: Terminal mode

**Macro Recording**
- 󰑋 **@{register}**: Shows when recording a macro (e.g., "󰑋 @q")
- Only appears when actively recording

**Git Information**
- 󰊢 **Branch Name**: Current git branch in green
- **Diff Statistics**:
  -  **+{count}**: Added lines (green)
  -  **~{count}**: Modified lines (orange)
  -  **-{count}**: Removed lines (red)

**Search Results**
- 󰍉 **{current}/{total}**: Search result position (e.g., "󰍉 3/15")
- Only shows when search highlighting is active

#### Center Section (lualine_c)

**File Information**
- **Filename**: Relative path from project root
- **File Status Icons**:
  - 󰳖 **Modified**: File has unsaved changes
  - 󰌾 **Readonly**: File is read-only
  - 󰡯 **[No Name]**: Unnamed buffer
  - 󰎔 **[New]**: New file not yet saved

**Unsaved File Indicator**
- 󰳖 **UNSAVED**: Prominent orange indicator when file has unsaved changes
- Disappears immediately after saving

**File Type**
- **Language Icon**: Colored icon representing the file type
- **Language Name**: Programming language or file type

**File Size**
- 󰈔 **Size**: Human-readable file size
  - Shows bytes (B), kilobytes (K), or megabytes (M)
  - Cyan color for easy visibility

#### Right Section (lualine_x, lualine_y, lualine_z)

**Python Environment** (Python files only)
- 󰌠 **{env_name}**: Active virtual environment
- Green color, bold text
- Only appears when editing Python files
- Shows conda or virtualenv name

**LSP Status**
- 󰒋 **{server_names}**: Active Language Server Protocol clients
- 󰌘 **No LSP**: When no language servers are running
- Purple color for easy identification
- Shows comma-separated list of active servers (e.g., "pyright, ruff")

**Smart Diagnostics**
- **Error States**:
  - 󰅚 **{count}**: Error count (red, bold when errors present)
  - 󰀪 **{count}**: Warning count (orange)
  - 󰌶 **{count}**: Hint count (blue)
  - 󰋽 **{count}**: Info count (cyan)
- 󰄬 **Clean**: Green indicator when no issues exist
- Dynamic color: red when errors present, green when clean

**File Encoding** (non-UTF-8 only)
- **UTF-8**, **UTF-16**, etc.: File character encoding
- Gray color, only shows when not UTF-8
- Uppercase format for clarity

**Line Endings** (non-Unix only)
- 󰌽 **LF**: Unix line endings (Linux/macOS)
- 󰌾 **CRLF**: Windows line endings
- 󰌼 **CR**: Classic Mac line endings
- Gray color, only shows when not Unix format

**Buffer Information**
- 󰓩 **{current}/{total}**: Current buffer position (e.g., "󰓩 2/5")
- Orange color for visibility
- Shows your position in the buffer list

**File Progress**
- 󰉸 **{percentage}**: Percentage through the file (e.g., "󰉸 45%")
- Cyan color
- Updates as you navigate through the file

**Cursor Location**
- 󰰤 **{line}:{column}**: Current cursor position (e.g., "󰰤 142:23")
- White color, bold text
- Essential for navigation and debugging

**System Time**
- 󰥔 **{HH:MM}**: Current time in 24-hour format
- Bold cyan color
- Useful for time tracking during coding sessions

### 🎯 Color Coding System

The statusline uses a consistent color scheme based on Monokai Pro:

- **🔴 Red (#ff6188)**: Errors, critical issues, remove operations
- **🟠 Orange (#fc9867)**: Warnings, modifications, unsaved changes
- **🟢 Green (#a9dc76)**: Success states, additions, git branch, Python env
- **🔵 Cyan (#78dce8)**: Information, file size, search results, time
- **🟣 Purple (#ab9df2)**: LSP servers, file types, special features
- **⚪ White (#fcfcfa)**: Primary text, filenames, cursor location
- **⚫ Gray (#727072)**: Secondary information, encoding, line endings

### 🔧 Interactive Features

**Hover Actions**
- **Buffer tabs**: Hover to see close buttons
- **Components**: Some components show additional information on hover

**Click Actions** (if mouse is enabled)
- **Buffer tabs**: Click to switch, right-click to close
- **Mode indicator**: May trigger mode-specific actions
- **Git diff**: Click to navigate to changes

### 🎨 Inactive Window Styling

When a window is inactive, the statusline shows minimal information:
- **Filename**: With modification indicators
- **Location**: Basic cursor position
- **Subdued colors**: Gray tones to indicate inactive state

This comprehensive statusline gives you everything you need to understand your current development context at a glance, from file status and git information to Python environments and system diagnostics.

## 🎯 Status Line Tips

1. **Monitor the diagnostics**: The smart diagnostics component changes color to red when errors are present
2. **Track unsaved changes**: The prominent "UNSAVED" indicator ensures you never lose work
3. **Environment awareness**: The Python environment indicator helps you stay in the right virtual environment
4. **Git workflow**: Use the diff statistics to see your changes at a glance
5. **Buffer navigation**: The buffer count helps you keep track of open files
6. **Search progress**: The search counter shows your position in search results
7. **Time tracking**: The clock helps with time management during coding sessions

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
8. **Git workflow**: `<leader>gs` for status, stage hunks with `<leader>gha`

The status line will show all relevant information: your active Python environment, git branch, LSP status, and diagnostics - everything you need for productive Python development!

## 🔧 Customization

All configuration is modular and easy to customize:
- Modify `lua/config/options.lua` for Vim settings
- Update `lua/config/keymaps.lua` for key bindings
- Edit plugin files in `lua/plugins/` to add/remove features
- Customize the status line in `lua/plugins/statusline.lua`

Enjoy your enhanced Neovim experience! 🎉
