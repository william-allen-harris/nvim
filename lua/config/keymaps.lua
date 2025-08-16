-- ┌──────────────────────┐
-- │ Global keymaps       │
-- └──────────────────────┘

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Tmux navigator mappings
vim.g.tmux_navigator_no_mappings = 1
local function map_tmux(m, lhs, rhs)
  vim.keymap.set(m, lhs, rhs, { silent = true, noremap = true })
end
map_tmux({ "n", "t" }, "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
map_tmux({ "n", "t" }, "<C-j>", "<cmd>TmuxNavigateDown<CR>")
map_tmux({ "n", "t" }, "<C-k>", "<cmd>TmuxNavigateUp<CR>")
map_tmux({ "n", "t" }, "<C-l>", "<cmd>TmuxNavigateRight<CR>")
map_tmux({ "n", "t" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>")

-- Telescope keybinds (loaded conditionally when telescope is available)
local function setup_telescope_keymaps()
  local ok_telescope, telescope = pcall(require, "telescope.builtin")
  if ok_telescope then
    map("n", "<leader>ff", telescope.find_files, opts)
    map("n", "<leader>fg", telescope.live_grep,  opts)
    map("n", "<leader>fb", telescope.buffers,    opts)
    map("n", "<leader>fh", telescope.help_tags,  opts)
    map("n", "<leader>fd", telescope.diagnostics, opts)
    map("n", "<leader>fc", telescope.commands, opts)
    map("n", "<leader>fk", telescope.keymaps, opts)
    map("n", "<leader>fm", telescope.marks, opts)
    map("n", "<leader>fj", telescope.jumplist, opts)
    map("n", "<leader>fo", telescope.oldfiles, opts)
    
    -- Git Telescope
    map("n", "<leader>gB", telescope.git_branches, { desc = "Git branches" })
    map("n", "<leader>gC", telescope.git_commits,  { desc = "Git commits" })
    map("n", "<leader>gS", telescope.git_status,   { desc = "Git status (Telescope)" })
    map("n", "<leader>gf", telescope.git_files,    { desc = "Git files" })
  end
end

-- Copilot
vim.g.copilot_no_tab_map = true
map("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true, replace_keycodes = false })

-- Harpoon keymaps (loaded conditionally when harpoon is available)
local function setup_harpoon_keymaps()
  local ok_mark, harpoon_mark = pcall(require, "harpoon.mark")
  local ok_ui, harpoon_ui = pcall(require, "harpoon.ui")
  if ok_mark and ok_ui then
    map("n", "<leader>a", harpoon_mark.add_file, { desc = "Harpoon add file" })
    map("n", "<leader>h", harpoon_ui.toggle_quick_menu, { desc = "Harpoon menu" })
    map("n", "<leader>1", function() harpoon_ui.nav_file(1) end, { desc = "Harpoon file 1" })
    map("n", "<leader>2", function() harpoon_ui.nav_file(2) end, { desc = "Harpoon file 2" })
    map("n", "<leader>3", function() harpoon_ui.nav_file(3) end, { desc = "Harpoon file 3" })
    map("n", "<leader>4", function() harpoon_ui.nav_file(4) end, { desc = "Harpoon file 4" })
  end
end

-- Venv selector
map("n", "<leader>vs", ":VenvSelect<CR>", { desc = "Select Python venv" })

-- Conform formatting
map("n", "<leader>F", function()
  require("conform").format({ async = true })
end, { desc = "Format buffer (Conform)" })

-- Buffer management with fast deletion
local function smart_delete_buffer()
  -- Try to use bufferline's close command if available
  local ok, bufferline = pcall(require, "bufferline")
  if ok then
    vim.cmd("BufferLineCloseOthers")
    return
  end
  
  -- Fallback to simple buffer navigation + delete
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())
  
  if #buffers > 1 then
    vim.cmd("bnext")
  else
    vim.cmd("enew")
  end
  
  vim.cmd("bdelete " .. current_buf)
end

-- Fast buffer deletion using bufferline
local function fast_delete_buffer()
  local ok, bufferline_api = pcall(require, "bufferline.api")
  if ok then
    bufferline_api.close_current()
  else
    -- Simple fallback
    if #vim.fn.getbufinfo({buflisted = 1}) > 1 then
      vim.cmd("bnext | bdelete #")
    else
      vim.cmd("enew | bdelete #")
    end
  end
end

map("n", "<leader>bd", fast_delete_buffer, { desc = "Delete buffer (fast)" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })
map("n", "<leader>bx", "<cmd>bdelete<cr>", { desc = "Delete buffer (default)" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Alternative vim-style buffer navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Additional buffer cycling (more convenient)
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Quick buffer switching (Alt + number for ordinal position)
for i = 1, 9 do
  map("n", "<A-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer " .. i })
end

-- Leader + number for buffer jumping (like Harpoon style but for buffers 5-9)
-- Note: <leader>1-4 are reserved for Harpoon files
for i = 5, 9 do
  map("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer " .. i })
end

-- Quick access to first few buffers with alternative keys
map("n", "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", { desc = "Go to buffer 1" })
map("n", "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", { desc = "Go to buffer 2" })
map("n", "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", { desc = "Go to buffer 3" })
map("n", "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", { desc = "Go to buffer 4" })
map("n", "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", { desc = "Go to buffer 5" })
map("n", "<leader>b6", "<cmd>BufferLineGoToBuffer 6<cr>", { desc = "Go to buffer 6" })
map("n", "<leader>b7", "<cmd>BufferLineGoToBuffer 7<cr>", { desc = "Go to buffer 7" })
map("n", "<leader>b8", "<cmd>BufferLineGoToBuffer 8<cr>", { desc = "Go to buffer 8" })
map("n", "<leader>b9", "<cmd>BufferLineGoToBuffer 9<cr>", { desc = "Go to buffer 9" })

-- Return setup functions for lazy loading
return {
  setup_telescope_keymaps = setup_telescope_keymaps,
  setup_harpoon_keymaps = setup_harpoon_keymaps,
}
