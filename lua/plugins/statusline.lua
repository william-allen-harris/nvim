-- ┌─────────────────────────────────────┐
-- │ Status line                        │
-- └─────────────────────────────────────┘

return {
  -- Comprehensive status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")

      -- Custom components for enhanced user experience
      local function python_venv()
        local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
        if venv then
          local venv_name = vim.fn.fnamemodify(venv, ":t")
          return "󰌠 " .. venv_name
        end
        return ""
      end

      local function lsp_status()
        local clients = vim.lsp.get_clients({ bufnr = 0 })

        if #clients == 0 then
          return ""
        end

        local client_names_set = {}
        for _, client in ipairs(clients) do
          client_names_set[client.name] = true
        end

        local client_names = {}
        for name, _ in pairs(client_names_set) do
          table.insert(client_names, name)
        end

        table.sort(client_names)
        return "󰒋 " .. table.concat(client_names, ", ")
      end

      local function macro_recording()
        local recording = vim.fn.reg_recording()
        if recording ~= "" then
          return "󰑋 @" .. recording
        end
        return ""
      end

      local function buffer_info()
        local buf_count = #vim.fn.getbufinfo({ buflisted = 1 })
        if buf_count <= 1 then
          return ""
        end
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_list = vim.fn.getbufinfo({ buflisted = 1 })
        local current_index = 1

        for i, buf in ipairs(buf_list) do
          if buf.bufnr == current_buf then
            current_index = i
            break
          end
        end

        return string.format("󰓩 %d/%d", current_index, buf_count)
      end

      -- Git ahead/behind remote
      local function git_ahead_behind()
        local handle = io.popen("git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null")
        if not handle then
          return ""
        end
        local result = handle:read("*a")
        handle:close()

        if result == "" then
          return ""
        end

        local ahead, behind = result:match("(%d+)%s+(%d+)")
        if not ahead or not behind then
          return ""
        end

        local parts = {}
        if tonumber(ahead) > 0 then
          table.insert(parts, "⇡" .. ahead)
        end
        if tonumber(behind) > 0 then
          table.insert(parts, "⇣" .. behind)
        end

        return table.concat(parts, " ")
      end

      -- Monokai Pro color palette
      local monokai = {
        bg = "#2d2a2e",
        bg_dark = "#221f22",
        fg = "#fcfcfa",
        gray = "#727072",
        gray_light = "#939293",
        yellow = "#ffd866",
        orange = "#fc9867",
        red = "#ff6188",
        magenta = "#ff6188",
        violet = "#ab9df2",
        blue = "#78dce8",
        cyan = "#78dce8",
        green = "#a9dc76",
      }

      -- Custom monokai-pro theme for lualine
      local monokai_theme = {
        normal = {
          a = { fg = monokai.bg_dark, bg = monokai.cyan, gui = "bold" },
          b = { fg = monokai.fg, bg = monokai.bg_dark },
          c = { fg = monokai.gray_light, bg = monokai.bg },
        },
        insert = {
          a = { fg = monokai.bg_dark, bg = monokai.green, gui = "bold" },
          b = { fg = monokai.fg, bg = monokai.bg_dark },
          c = { fg = monokai.gray_light, bg = monokai.bg },
        },
        visual = {
          a = { fg = monokai.bg_dark, bg = monokai.violet, gui = "bold" },
          b = { fg = monokai.fg, bg = monokai.bg_dark },
          c = { fg = monokai.gray_light, bg = monokai.bg },
        },
        replace = {
          a = { fg = monokai.bg_dark, bg = monokai.red, gui = "bold" },
          b = { fg = monokai.fg, bg = monokai.bg_dark },
          c = { fg = monokai.gray_light, bg = monokai.bg },
        },
        command = {
          a = { fg = monokai.bg_dark, bg = monokai.yellow, gui = "bold" },
          b = { fg = monokai.fg, bg = monokai.bg_dark },
          c = { fg = monokai.gray_light, bg = monokai.bg },
        },
        inactive = {
          a = { fg = monokai.gray, bg = monokai.bg_dark },
          b = { fg = monokai.gray, bg = monokai.bg_dark },
          c = { fg = monokai.gray, bg = monokai.bg },
        },
      }

      lualine.setup({
        options = {
          theme = monokai_theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "NvimTree", "alpha", "dashboard", "aerial", "toggleterm", "snacks_dashboard" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 500,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:sub(1, 1)
              end,
            },
          },
          lualine_b = {
            {
              macro_recording,
              color = { fg = monokai.red, gui = "bold" },
              cond = function()
                return vim.fn.reg_recording() ~= ""
              end,
            },
            {
              "branch",
              icon = "",
              color = { fg = monokai.violet },
            },
            {
              "diff",
              symbols = { added = "+", modified = "~", removed = "-" },
              diff_color = {
                added = { fg = monokai.green },
                modified = { fg = monokai.orange },
                removed = { fg = monokai.red },
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            {
              git_ahead_behind,
              color = { fg = monokai.cyan },
              cond = function()
                return vim.fn.isdirectory(".git") == 1
              end,
            },
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = true,
              path = 1,
              shorting_target = 30,
              symbols = {
                modified = "●",
                readonly = "",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
              color = { fg = monokai.fg },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              diagnostics_color = {
                error = { fg = monokai.red },
                warn = { fg = monokai.orange },
                info = { fg = monokai.blue },
                hint = { fg = monokai.cyan },
              },
            },
            {
              python_venv,
              color = { fg = monokai.green },
              cond = function()
                return vim.bo.filetype == "python"
              end,
            },
            {
              lsp_status,
              color = { fg = monokai.gray_light },
            },
          },
          lualine_y = {
            {
              buffer_info,
              color = { fg = monokai.gray_light },
            },
            {
              "filetype",
              colored = false,
              icon_only = true,
              color = { fg = monokai.gray_light },
            },
            {
              "progress",
              color = { fg = monokai.gray_light },
            },
          },
          lualine_z = {
            {
              "location",
              color = { fg = monokai.bg_dark, bg = monokai.cyan, gui = "bold" },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = "●",
                readonly = "",
                unnamed = "[No Name]",
              },
              color = { fg = monokai.gray },
            },
          },
          lualine_x = {
            {
              "location",
              color = { fg = monokai.gray },
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "toggleterm", "fugitive", "quickfix" },
      })
    end,
  },
}
