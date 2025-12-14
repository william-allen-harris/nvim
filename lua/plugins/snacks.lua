-- ┌─────────────────────────────────────┐
-- │ Snacks.nvim - Modern utilities     │
-- └─────────────────────────────────────┘

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Handle large files gracefully
      bigfile = { enabled = true },

      -- Better notifications (replaces vim.notify)
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact",
      },

      -- Fast file opening
      quickfile = { enabled = true },

      -- Better vim.ui.input
      input = { enabled = true },

      -- Indent guides
      indent = {
        enabled = true,
        char = "│",
        scope = {
          enabled = true,
          char = "│",
        },
      },

      -- Scope highlighting
      scope = { enabled = true },

      -- Smooth scrolling
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 150 },
        },
      },

      -- Jump between references (like * but better)
      words = {
        enabled = true,
        debounce = 200,
      },

      -- Zen mode for focused editing
      zen = {
        enabled = true,
        toggles = {
          dim = true,
          git_signs = false,
          diagnostics = false,
        },
      },

      -- Better terminal
      terminal = { enabled = true },

      -- Dashboard (optional, comment out if you prefer instant editing)
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },

      -- Statuscolumn
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = {
          open = false,
          git_hl = false,
        },
        git = {
          patterns = { "GitSign" },
        },
        refresh = 50,
      },

      -- Git utilities
      git = { enabled = true },
      gitbrowse = { enabled = true },

      -- Lazygit integration
      lazygit = { enabled = true },

      -- Rename with LSP support
      rename = { enabled = true },

      -- Scratch buffers
      scratch = { enabled = true },

      -- Buffer deletion without closing windows
      bufdelete = { enabled = true },
    },
    keys = {
      -- Notifications
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification history" },

      -- Terminal
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
      -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" }, -- Requires: brew install lazygit

      -- Git
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse (open in browser)" },
      { "<leader>gL", function() Snacks.git.blame_line() end, desc = "Git blame line" },

      -- Zen mode
      { "<leader>z", function() Snacks.zen() end, desc = "Toggle zen mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle zoom" },

      -- Scratch buffers
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select scratch buffer" },

      -- Words navigation (jump between references)
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },

      -- Buffer delete (better than :bdelete)
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Delete all buffers" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

      -- Rename
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
    },
    init = function()
      -- Setup some globals for debugging (nice to have)
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Global debug functions
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd

          -- Toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
