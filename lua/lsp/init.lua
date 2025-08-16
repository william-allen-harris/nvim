-- ┌────────────────────────────┐
-- │ LSP capabilities + servers │
-- └────────────────────────────┘

local M = {}

-- Global LSP keymaps (buffer-local on attach)
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
  end
  
  -- Telescope-enhanced LSP mappings
  local telescope_builtin = require("telescope.builtin")
  
  map("n", "gd", telescope_builtin.lsp_definitions, "Go to definition (Telescope)")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gr", telescope_builtin.lsp_references, "References (Telescope)")
  map("n", "gi", telescope_builtin.lsp_implementations, "Implementation (Telescope)")
  map("n", "gt", telescope_builtin.lsp_type_definitions, "Type definition (Telescope)")
  map("n", "<leader>ds", telescope_builtin.lsp_document_symbols, "Document symbols (Telescope)")
  map("n", "<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "Workspace symbols (Telescope)")
  map("n", "K",  vim.lsp.buf.hover, "Hover docs")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  
  -- Additional Telescope LSP mappings
  map("n", "<leader>ic", telescope_builtin.lsp_incoming_calls, "Incoming calls (Telescope)")
  map("n", "<leader>oc", telescope_builtin.lsp_outgoing_calls, "Outgoing calls (Telescope)")
end

function M.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Ruff LSP setup
  lspconfig.ruff.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      on_attach(client, bufnr)
    end,
  })

  -- Pyright setup
  lspconfig.pyright.setup({ 
    capabilities = capabilities, 
    on_attach = on_attach 
  })
end

return M
