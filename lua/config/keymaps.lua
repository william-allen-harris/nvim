-- ┌──────────────────────┐
-- │ Global keymaps       │
-- └──────────────────────┘

local map = vim.keymap.set

-- ┌──────────────────────┐
-- │ Tmux navigation      │
-- └──────────────────────┘
vim.g.tmux_navigator_no_mappings = 1
map({ "n", "t" }, "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate left" })
map({ "n", "t" }, "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate down" })
map({ "n", "t" }, "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate up" })
map({ "n", "t" }, "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate right" })
map({ "n", "t" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", { desc = "Navigate previous" })

-- ┌──────────────────────┐
-- │ Git operations       │
-- └──────────────────────┘
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

-- ┌──────────────────────┐
-- │ Better defaults      │
-- └──────────────────────┘
-- Better escape
map("i", "jk", "<Esc>", { desc = "Escape" })
map("i", "kj", "<Esc>", { desc = "Escape" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better window navigation (when not using tmux)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Don't yank on paste in visual mode
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Quick save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })

-- Quick quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

-- Split windows
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })

-- ┌──────────────────────┐
-- │ Diagnostics          │
-- └──────────────────────┘
map("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
