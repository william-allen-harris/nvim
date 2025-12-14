-- Pyright LSP configuration
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
  on_init = function(client)
    -- Auto-detect virtualenv
    local path = client.config.root_dir or vim.fn.getcwd()
    local venv_paths = { ".venv", "venv", ".env", "env" }
    for _, venv in ipairs(venv_paths) do
      local venv_python = path .. "/" .. venv .. "/bin/python"
      if vim.fn.executable(venv_python) == 1 then
        client.config.settings.python.pythonPath = venv_python
        client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        break
      end
    end
  end,
}
