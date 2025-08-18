-- ┌──────────────────────────────────────────┐
-- │ Diagnostics: UI, keybinds, quick toggles │
-- └──────────────────────────────────────────┘

vim.diagnostic.config({
  virtual_text = false, -- Hide virtual text by default
  float = { border = "rounded", source = "if_many" },
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.HINT]  = "H",
      [vim.diagnostic.severity.INFO]  = "I",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    },
  },
})

-- Hover line diagnostics (auto + manual)
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
  end,
})

vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
end, { desc = "Line diagnostics" })

-- Toggle inline diagnostics
local vt_enabled = false -- Start with virtual text disabled
vim.keymap.set("n", "<leader>tv", function()
  vt_enabled = not vt_enabled
  vim.diagnostic.config({ virtual_text = vt_enabled })
  vim.notify("virtual_text = " .. tostring(vt_enabled))
end, { desc = "Toggle diagnostics virtual text" })

-- ┌───────────────────────────────┐
-- │ Autosave on InsertLeave only  │
-- └───────────────────────────────┘
local uv = vim.uv or vim.loop
local autosave_timer
local function autosave_current_buf()
  local buf = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.bo[buf].buftype ~= "" then return end
  if vim.bo[buf].readonly or not vim.bo[buf].modifiable then return end
  if vim.bo[buf].filetype == "" then return end
  if vim.api.nvim_buf_get_option(buf, "modified") then
    vim.cmd("silent keepalt keepjumps update")
  end
end

local function schedule_autosave(ms)
  if autosave_timer then autosave_timer:stop(); autosave_timer:close() end
  autosave_timer = uv.new_timer()
  autosave_timer:start(ms, 0, vim.schedule_wrap(autosave_current_buf))
end

local autosave_group = vim.api.nvim_create_augroup("AutoSaveOnInsertLeave", { clear = true })
-- Only autosave when leaving insert mode with 1 second delay
vim.api.nvim_create_autocmd("InsertLeave", {
  group = autosave_group,
  callback = function() schedule_autosave(1000) end, -- 1 second delay
})
-- Also save on focus lost and buffer leave for safety
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = autosave_group,
  callback = autosave_current_buf,
})

-- Toggle autosave
local autosave_enabled = true
vim.keymap.set("n", "<leader>as", function()
  autosave_enabled = not autosave_enabled
  if autosave_enabled then
    vim.api.nvim_del_augroup_by_name("AutoSaveOnInsertLeave")
    autosave_group = vim.api.nvim_create_augroup("AutoSaveOnInsertLeave", { clear = true })
    -- Only autosave when leaving insert mode with 1 second delay
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = autosave_group,
      callback = function() schedule_autosave(1000) end, -- 1 second delay
    })
    -- Also save on focus lost and buffer leave for safety
    vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
      group = autosave_group,
      callback = autosave_current_buf,
    })
    vim.notify("Autosave: ON (InsertLeave + 1s delay)")
  else
    pcall(vim.api.nvim_del_augroup_by_name, "AutoSaveOnInsertLeave")
    vim.notify("Autosave: OFF")
  end
end, { desc = "Toggle autosave" })

-- ┌───────────────────────────────┐
-- │ Uv project bootstrap command │
-- └───────────────────────────────┘
vim.api.nvim_create_user_command("UvInit", function()
  local has_uv = vim.fn.executable("uv") == 1
  if not has_uv then
    vim.notify("uv not found. Install from https://docs.astral.sh/uv/ first.", vim.log.levels.ERROR)
    return
  end
  local cmd = [[bash -lc 'set -euo pipefail; uv venv --python 3 || true; source .venv/bin/activate && uv pip install -U ruff ruff-lsp pyright']]
  vim.fn.jobstart(cmd, { cwd = vim.fn.getcwd(), detach = true })
  vim.notify("Bootstrapping .venv with ruff, ruff-lsp, pyright via uv…", vim.log.levels.INFO)
end, {})

-- ┌────────────────────────────────────┐
-- │ Status line refresh & enhancements │
-- └────────────────────────────────────┘
-- Refresh status line when LSP attaches/detaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspStatusRefresh", { clear = true }),
  callback = function(ev)
    -- Only redraw if we have a valid buffer
    if ev.buf and vim.api.nvim_buf_is_valid(ev.buf) then
      vim.schedule(function()
        pcall(vim.cmd, "redrawstatus")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("LspStatusRefresh", { clear = false }),
  callback = function(ev)
    -- Only redraw if we have a valid buffer
    if ev.buf and vim.api.nvim_buf_is_valid(ev.buf) then
      vim.schedule(function()
        pcall(vim.cmd, "redrawstatus")
      end)
    end
  end,
})

-- Refresh status line when git branch changes
vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  group = vim.api.nvim_create_augroup("GitStatusRefresh", { clear = true }),
  callback = function()
    vim.schedule(function()
      pcall(vim.cmd, "redrawstatus")
    end)
  end,
})

-- Refresh status line when entering/leaving insert mode (for macro recording)
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("InsertStatusRefresh", { clear = true }),
  callback = function()
    vim.schedule(function()
      pcall(vim.cmd, "redrawstatus")
    end)
  end,
})
