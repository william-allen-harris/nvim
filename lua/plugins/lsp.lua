-- ┌─────────────────────────────────────┐
-- │ LSP, Mason & Formatting (unified)  │
-- └─────────────────────────────────────┘

return {
  -- Mason: Package manager for LSP servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason-lspconfig for automatic server installation
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "pyright", "ruff", "lua_ls" },
      automatic_installation = true,
    },
  },

  -- LSP Configuration (using vim.lsp.config for Neovim 0.11+)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Global LSP configuration for all servers
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        root_markers = { ".git" },
      })

      -- Enable LSP servers (configs are in lsp/*.lua)
      vim.lsp.enable({ "pyright", "ruff", "lua_ls" })

      -- LspAttach autocmd for keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
          end

          -- Use Snacks picker if available, fallback to Telescope
          local has_snacks, snacks = pcall(require, "snacks")
          local has_telescope, telescope = pcall(require, "telescope.builtin")

          if has_snacks and snacks.picker then
            map("n", "gd", function() snacks.picker.lsp_definitions() end, "Go to definition")
            map("n", "gr", function() snacks.picker.lsp_references() end, "References")
            map("n", "gi", function() snacks.picker.lsp_implementations() end, "Implementation")
            map("n", "gt", function() snacks.picker.lsp_type_definitions() end, "Type definition")
            map("n", "<leader>ds", function() snacks.picker.lsp_symbols() end, "Document symbols")
            map("n", "<leader>ws", function() snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")
          elseif has_telescope then
            map("n", "gd", telescope.lsp_definitions, "Go to definition")
            map("n", "gr", telescope.lsp_references, "References")
            map("n", "gi", telescope.lsp_implementations, "Implementation")
            map("n", "gt", telescope.lsp_type_definitions, "Type definition")
            map("n", "<leader>ds", telescope.lsp_document_symbols, "Document symbols")
            map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, "Workspace symbols")
          else
            map("n", "gd", vim.lsp.buf.definition, "Go to definition")
            map("n", "gr", vim.lsp.buf.references, "References")
            map("n", "gi", vim.lsp.buf.implementation, "Implementation")
            map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
          end

          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "K", vim.lsp.buf.hover, "Hover docs")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
          map("n", "<leader>dl", vim.diagnostic.open_float, "Line diagnostics")

          -- Incoming/outgoing calls
          if has_telescope then
            map("n", "<leader>ic", telescope.lsp_incoming_calls, "Incoming calls")
            map("n", "<leader>oc", telescope.lsp_outgoing_calls, "Outgoing calls")
          end
        end,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = true,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- Formatting with Conform
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1500,
      },
    },
  },

  -- Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
        expr = true,
        silent = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
    end,
  },
}
