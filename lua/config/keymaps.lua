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
    
    -- Git Telescope - Complete workflow
    map("n", "<leader>gf", telescope.git_files,    { desc = "Git files" })
    map("n", "<leader>gs", telescope.git_status,   { desc = "Git status" })
    map("n", "<leader>gb", telescope.git_branches, { desc = "Git branches" })
    map("n", "<leader>gc", telescope.git_commits,  { desc = "Git commits" })
    map("n", "<leader>gh", telescope.git_stash,    { desc = "Git stash" })
    
    -- Git diff
    map("n", "<leader>gd", function()
      vim.cmd("DiffviewOpen")
    end, { desc = "Git diff view" })
    
    -- Git log
    map("n", "<leader>gl", telescope.git_commits,  { desc = "Git log" })
    
    -- Git operations
    map("n", "<leader>ga", "<cmd>!git add .<cr>", { desc = "Git add all" })
    map("n", "<leader>gm", function()
      vim.ui.input({ prompt = "Commit message: " }, function(msg)
        if msg and msg ~= "" then
          vim.cmd('!git commit -m "' .. msg .. '"')
          vim.cmd("checktime")
        end
      end)
    end, { desc = "Git commit" })
    map("n", "<leader>gp", "<cmd>!git push<cr>", { desc = "Git push" })
    map("n", "<leader>gv", function()
      local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
      if branch ~= "" then
        vim.cmd("!git push --set-upstream origin " .. branch)
      else
        vim.notify("Not on a git branch", vim.log.levels.WARN)
      end
    end, { desc = "Git push upstream" })
    map("n", "<leader>gu", "<cmd>!git pull<cr>", { desc = "Git pull" })
    map("n", "<leader>gF", "<cmd>!git fetch<cr>", { desc = "Git fetch" })
    map("n", "<leader>gM", function()
      vim.cmd("!git fetch origin")
      local main_exists = vim.fn.system("git show-ref --verify --quiet refs/heads/main")
      local branch = main_exists:find("^0") and "main" or "master"
      vim.cmd("!git checkout " .. branch .. " && git pull origin " .. branch .. " && git checkout - && git merge " .. branch)
    end, { desc = "Git merge main/master (update first)" })
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

-- Quick access to buffers by ordinal position (matches the numbers shown in bufferline)
local function goto_buffer_by_ordinal(num)
  return function()
    local ok, bufferline_state = pcall(require, "bufferline.state")
    if not ok then
      vim.notify("BufferLine not available", vim.log.levels.WARN)
      return
    end
    
    local buffers = bufferline_state.components
    if buffers and buffers[num] then
      vim.api.nvim_set_current_buf(buffers[num].id)
    else
      vim.notify("Buffer " .. num .. " not found", vim.log.levels.WARN)
    end
  end
end

map("n", "<leader>b1", goto_buffer_by_ordinal(1), { desc = "Go to buffer 1" })
map("n", "<leader>b2", goto_buffer_by_ordinal(2), { desc = "Go to buffer 2" })
map("n", "<leader>b3", goto_buffer_by_ordinal(3), { desc = "Go to buffer 3" })
map("n", "<leader>b4", goto_buffer_by_ordinal(4), { desc = "Go to buffer 4" })
map("n", "<leader>b5", goto_buffer_by_ordinal(5), { desc = "Go to buffer 5" })
map("n", "<leader>b6", goto_buffer_by_ordinal(6), { desc = "Go to buffer 6" })
map("n", "<leader>b7", goto_buffer_by_ordinal(7), { desc = "Go to buffer 7" })
map("n", "<leader>b8", goto_buffer_by_ordinal(8), { desc = "Go to buffer 8" })
map("n", "<leader>b9", goto_buffer_by_ordinal(9), { desc = "Go to buffer 9" })

-- Return setup functions for lazy loading
return {
  setup_telescope_keymaps = setup_telescope_keymaps,
  setup_harpoon_keymaps = setup_harpoon_keymaps,
}
