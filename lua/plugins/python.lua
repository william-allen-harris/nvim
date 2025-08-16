-- ┌─────────────────────────────────────┐
-- │ Python-specific development tools   │
-- └─────────────────────────────────────┘

return {
  -- Enhanced Python environment detection and display
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      options = {
        enable_default_searches = true,
        enable_cached_venvs = true,
        cached_venv_automatic_activation = true,
        notify_user_on_venv_activation = true,
      },
      search = {
        cwd = { command = "fd '/bin/python$' $CWD --full-path --color never -E /proc -I -a -L" },
        anaconda_base = { command = "fd '/bin/python$' ~/anaconda3/envs --full-path --color never" },
        anaconda_envs = { command = "fd '/bin/python$' ~/anaconda3/envs --full-path --color never" },
        miniconda_base = { command = "fd '/bin/python$' ~/miniconda3/envs --full-path --color never" },
        miniconda_envs = { command = "fd '/bin/python$' ~/miniconda3/envs --full-path --color never" },
        poetry = { command = "fd '/bin/python$' ~/.cache/pypoetry/virtualenvs --full-path --color never" },
        pipenv = { command = "fd '/bin/python$' ~/.local/share/virtualenvs --full-path --color never" },
      },
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Activate cached venv" },
    },
  },

  -- Better Python syntax and indentation
  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },

  -- Python docstring generator
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
        },
      })
      
      vim.keymap.set("n", "<leader>nf", function()
        require("neogen").generate({ type = "func" })
      end, { desc = "Generate function docstring" })
      
      vim.keymap.set("n", "<leader>nc", function()
        require("neogen").generate({ type = "class" })
      end, { desc = "Generate class docstring" })
      
      vim.keymap.set("n", "<leader>nt", function()
        require("neogen").generate({ type = "type" })
      end, { desc = "Generate type docstring" })
    end,
  },

  -- Python test runner integration
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG", "-v" },
            runner = "pytest",
            python = function()
              local venv = vim.env.VIRTUAL_ENV
              if venv then
                return venv .. "/bin/python"
              end
              return vim.fn.exepath("python3") or vim.fn.exepath("python")
            end,
            pytest_discover_instances = true,
            -- Patterns for test discovery
            is_test_file = function(file_path)
              return file_path:match("test_.*%.py$") or 
                     file_path:match(".*_test%.py$") or
                     file_path:match("tests/.*%.py$") or
                     file_path:match("test/.*%.py$")
            end,
          }),
        },
        discovery = {
          enabled = true,
          concurrent = 1,
        },
        running = {
          concurrent = true,
        },
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            output = "o",
            short = "O",
            attach = "a",
            jumpto = "i",
            stop = "u",
            run = "r",
            debug = "d",
            mark = "m",
            run_marked = "R",
            debug_marked = "D",
            clear_marked = "M",
            target = "t",
            clear_target = "T",
            next_failed = "J",
            prev_failed = "K",
          },
          open = "botright vsplit | vertical resize 50",
        },
        output = {
          enabled = true,
          open_on_run = "short",
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        status = {
          enabled = true,
          virtual_text = false,
          signs = true,
        },
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✓",
          running = "●",
          running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
          skipped = "○",
          unknown = "?",
        },
      })
      
      -- Test runner keymaps
      vim.keymap.set("n", "<leader>tt", function()
        require("neotest").run.run()
      end, { desc = "Run nearest test" })
      
      vim.keymap.set("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Run file tests" })
      
      vim.keymap.set("n", "<leader>td", function()
        require("neotest").run.run({ strategy = "dap" })
      end, { desc = "Debug nearest test" })
      
      vim.keymap.set("n", "<leader>ts", function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle test summary" })
      
      vim.keymap.set("n", "<leader>to", function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end, { desc = "Show test output" })

      vim.keymap.set("n", "<leader>tO", function()
        require("neotest").output_panel.toggle()
      end, { desc = "Toggle test output panel" })
      
      vim.keymap.set("n", "<leader>tr", function()
        require("neotest").run.run_last()
      end, { desc = "Run last test" })
      
      vim.keymap.set("n", "<leader>ta", function()
        require("neotest").run.run(vim.fn.getcwd())
      end, { desc = "Run all tests" })

      vim.keymap.set("n", "<leader>tS", function()
        require("neotest").run.stop()
      end, { desc = "Stop tests" })
    end,
  },

  -- Python REPL integration
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = function()
                local venv = vim.env.VIRTUAL_ENV
                if venv then
                  return { venv .. "/bin/python" }
                end
                return { "python3" }
              end,
              format = require("iron.fts.python").ipython,
            },
          },
          repl_open_cmd = require("iron.view").bottom(40),
        },
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true,
      })
      
      -- Python REPL keymaps
      vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr>", { desc = "Start REPL" })
      vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>", { desc = "Restart REPL" })
      vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Focus REPL" })
      vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Hide REPL" })
    end,
  },
}
