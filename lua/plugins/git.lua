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
        -- Remapped from <leader>hs to avoid Harpoon conflict
        map({ "n", "v" }, "<leader>gha", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        -- Remapped from <leader>hr
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        -- Remapped from <leader>hS
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        -- Remapped from <leader>hu
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
        -- Remapped from <leader>hp
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        -- Remapped from <leader>hb
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line (popup)")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle git blame virtual text")
        -- Remapped from <leader>hd
        map("n", "<leader>ghd", gs.diffthis, "Diff vs index")
        -- Remapped from <leader>hD
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff vs last commit")
        -- Remapped from <leader>ht
        map("n", "<leader>ght", gs.toggle_current_line_blame, "Toggle gitsigns line blame")
        -- Remapped from <leader>hw
        map("n", "<leader>ghw", gs.toggle_word_diff, "Toggle word diff")
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
