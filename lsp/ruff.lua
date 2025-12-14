-- Ruff LSP configuration
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  on_attach = function(client)
    -- Disable formatting (handled by conform)
    client.server_capabilities.documentFormattingProvider = false
  end,
}
