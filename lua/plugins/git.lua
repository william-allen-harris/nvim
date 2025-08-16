-- ┌─────────────────────┐
-- │ Git integration     │
-- └─────────────────────┘

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      -- Disable current line blame to avoid duplication with git-blame.nvim
      current_line_blame = false,
      current_line_blame_opts = { delay = 500 },
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line (popup)")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle git blame virtual text")
        map("n", "<leader>hd", gs.diffthis, "Diff vs index")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff vs last commit")
        map("n", "<leader>ht", gs.toggle_current_line_blame, "Toggle gitsigns line blame")
        map("n", "<leader>hw", gs.toggle_word_diff, "Toggle word diff")
      end,
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gblame", "Gclog", "Gbrowse" },
    keys = {
      { "<leader>gs", "<cmd>Git<CR>",        desc = "Git status (fugitive)" },
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<CR>",   desc = "Git push" },
      { "<leader>gP", "<cmd>Git pull<CR>",   desc = "Git pull" },
    },
  },
  { 
    "sindrets/diffview.nvim", 
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" }, 
    config = true 
  },
}
