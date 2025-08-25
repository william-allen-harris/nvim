-- ┌─────────────────────────────────────┐
-- │ Status line & tab line (bufferline) │
-- └─────────────────────────────────────┘

return {
  -- Enhanced tab/buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          themable = true,
          numbers = "none", -- Remove numbers from tabs
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▍", -- Slightly thicker indicator
            style = "icon",
          },
          buffer_close_icon = "󰖭",
          modified_icon = "●",
          close_icon = "󰅖",
          left_trunc_marker = "󰁍",
          right_trunc_marker = "󰁔",
          max_name_length = 20, -- Slightly longer names
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 20,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and "󰅚 " or level:match("warn") and "󰀪 " or "󰌶 "
            return " " .. icon .. count
          end,
          custom_filter = function(buf_number, buf_numbers)
            -- Filter out certain file types
            if vim.bo[buf_number].filetype ~= "help" and vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "󰙅 File Explorer",
              text_align = "center",
              separator = true,
            },
            {
              filetype = "aerial",
              text = "󰙅 Outline",
              text_align = "center",
              separator = true,
            }
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin", -- Cleaner look
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 150, -- Faster hover response
            reveal = {"close"},
          },
          sort_by = "insert_after_current",
        },
        highlights = {
          -- Ensure Monokai Pro colors are applied correctly
          fill = {
            fg = "#727072",
            bg = "#2d2a2e",
          },
          background = {
            fg = "#727072",
            bg = "#2d2a2e",
          },
          buffer_visible = {
            fg = "#fcfcfa",
            bg = "#403e41",
          },
          buffer_selected = {
            fg = "#fcfcfa",
            bg = "#403e41",
            bold = true,
          },
          -- Fix number highlighting with explicit colors
          numbers = {
            fg = "#78dce8", -- Cyan for inactive
            bg = "#2d2a2e",
          },
          numbers_visible = {
            fg = "#a9dc76", -- Green for visible
            bg = "#403e41",
          },
          numbers_selected = {
            fg = "#ff6188", -- Pink for active
            bg = "#403e41",
            bold = true,
          },
          close_button = {
            fg = "#727072",
            bg = "#2d2a2e",
          },
          close_button_visible = {
            fg = "#fcfcfa",
            bg = "#403e41",
          },
          close_button_selected = {
            fg = "#ff6188",
            bg = "#403e41",
          },
          modified = {
            fg = "#fc9867",
            bg = "#2d2a2e",
          },
          modified_visible = {
            fg = "#fc9867",
            bg = "#403e41",
          },
          modified_selected = {
            fg = "#fc9867",
            bg = "#403e41",
          },
          separator = {
            fg = "#2d2a2e",
            bg = "#2d2a2e",
          },
          separator_visible = {
            fg = "#403e41",
            bg = "#2d2a2e",
          },
          separator_selected = {
            fg = "#403e41",
            bg = "#2d2a2e",
          },
          indicator_selected = {
            fg = "#ff6188",
            bg = "#403e41",
          },
          -- Diagnostic colors
          error = {
            fg = "#ff6188",
            bg = "#2d2a2e",
          },
          error_visible = {
            fg = "#ff6188",
            bg = "#403e41",
          },
          error_selected = {
            fg = "#ff6188",
            bg = "#403e41",
          },
          warning = {
            fg = "#fc9867",
            bg = "#2d2a2e",
          },
          warning_visible = {
            fg = "#fc9867",
            bg = "#403e41",
          },
          warning_selected = {
            fg = "#fc9867",
            bg = "#403e41",
          },
          info = {
            fg = "#78dce8",
            bg = "#2d2a2e",
          },
          info_visible = {
            fg = "#78dce8",
            bg = "#403e41",
          },
          info_selected = {
            fg = "#78dce8",
            bg = "#403e41",
          },
          hint = {
            fg = "#ab9df2",
            bg = "#2d2a2e",
          },
          hint_visible = {
            fg = "#ab9df2",
            bg = "#403e41",
          },
          hint_selected = {
            fg = "#ab9df2",
            bg = "#403e41",
          },
        },
      })
      
      -- Force highlight refresh after colorscheme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.schedule(function()
            -- Re-apply bufferline highlights
            local bufferline_highlights = require("bufferline.highlights")
            bufferline_highlights.set_all()
          end)
        end,
      })
    end,
  },

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
        -- Use the current API to get LSP clients
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        
        if #clients == 0 then
          return "󰌘 No LSP"
        end
        
        -- Use a set to deduplicate client names
        local client_names_set = {}
        for _, client in ipairs(clients) do
          client_names_set[client.name] = true
        end
        
        -- Convert set back to array
        local client_names = {}
        for name, _ in pairs(client_names_set) do
          table.insert(client_names, name)
        end
        
        table.sort(client_names) -- Sort for consistent display
        return "󰒋 " .. table.concat(client_names, ", ")
      end

      local function smart_diagnostics()
        local diagnostics = vim.diagnostic.get(0)
        local count = { errors = 0, warnings = 0, info = 0, hints = 0 }
        
        for _, diagnostic in ipairs(diagnostics) do
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            count.errors = count.errors + 1
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            count.warnings = count.warnings + 1
          elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            count.info = count.info + 1
          elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            count.hints = count.hints + 1
          end
        end
        
        local parts = {}
        if count.errors > 0 then table.insert(parts, "󰅚 " .. count.errors) end
        if count.warnings > 0 then table.insert(parts, "󰀪 " .. count.warnings) end
        if count.hints > 0 then table.insert(parts, "󰌶 " .. count.hints) end
        if count.info > 0 then table.insert(parts, "󰋽 " .. count.info) end
        
        if #parts == 0 then
          return "󰄬 Clean"
        end
        
        return table.concat(parts, " ")
      end

      local function git_blame()
        local blame = vim.b.gitsigns_blame_line
        if blame and blame ~= "" and blame ~= "Not Committed Yet" then
          local author = blame:match("([^,]+)")
          if author and #author > 15 then
            author = author:sub(1, 12) .. "..."
          end
          return "󰊢 " .. (author or "Unknown")
        end
        return ""
      end

      local function smart_file_size()
        local size = vim.fn.getfsize(vim.fn.expand("%:p"))
        if size < 0 then
          return ""
        elseif size < 1024 then
          return "󰈔 " .. size .. "B"
        elseif size < 1024 * 1024 then
          return "󰈔 " .. string.format("%.1fK", size / 1024)
        else
          return "󰈔 " .. string.format("%.1fM", size / (1024 * 1024))
        end
      end

      local function macro_recording()
        local recording = vim.fn.reg_recording()
        if recording ~= "" then
          return "󰑋 @" .. recording
        end
        return ""
      end

      local function buffer_info()
        local buf_count = #vim.fn.getbufinfo({buflisted = 1})
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_list = vim.fn.getbufinfo({buflisted = 1})
        local current_index = 1
        
        for i, buf in ipairs(buf_list) do
          if buf.bufnr == current_buf then
            current_index = i
            break
          end
        end
        
        return string.format("󰓩 %d/%d", current_index, buf_count)
      end

      local function search_count()
        -- Only show while actively searching (command-line type is '/' or '?')
        local cmd = vim.fn.getcmdtype()
        if cmd ~= '/' and cmd ~= '?' then
          return ""
        end
        
        -- Also require search highlighting to be on
        if vim.v.hlsearch == 0 then
          return ""
        end
        
        -- Validate the search pattern
        local search_pattern = vim.fn.getreg('/')
        if not search_pattern or search_pattern == '' or search_pattern == '\\%^' then
          return ""
        end
        
        -- Ensure the pattern actually exists in the current buffer
        local found_pos = vim.fn.searchpos(search_pattern, 'nw')
        if found_pos[1] == 0 and found_pos[2] == 0 then
          return ""
        end
        
        -- Compute the current/total counts
        local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 100 })
        if not ok or not result or result.total == 0 or result.current == 0 then
          return ""
        end
        
        return string.format("󰍉 %d/%d", result.current, result.total)
      end

      local function modified_indicator()
        if vim.bo.modified then
          return "UNSAVED"
        end
        return ""
      end

      local function git_unstaged_stats()
        local handle = io.popen("git status --porcelain 2>/dev/null")
        if not handle then return "" end
        local result = handle:read("*a")
        handle:close()
        
        if result == "" then return "" end
        
        local unstaged = 0
        local staged = 0
        for line in result:gmatch("[^\r\n]+") do
          local status = line:sub(1, 2)
          if status:sub(2, 2) ~= " " then
            unstaged = unstaged + 1
          end
          if status:sub(1, 1) ~= " " and status:sub(1, 1) ~= "?" then
            staged = staged + 1
          end
        end
        
        local parts = {}
        if staged > 0 then
          table.insert(parts, "󰐖 " .. staged)
        end
        if unstaged > 0 then
          table.insert(parts, "󰄱 " .. unstaged)
        end
        
        return table.concat(parts, " ")
      end

      local function git_commit_diff()
        local handle = io.popen("git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null")
        if not handle then return "" end
        local result = handle:read("*a")
        handle:close()
        
        if result == "" then return "" end
        
        local ahead, behind = result:match("(%d+)%s+(%d+)")
        if not ahead or not behind then return "" end
        
        local parts = {}
        if tonumber(ahead) > 0 then
          table.insert(parts, "󰜷 " .. ahead)
        end
        if tonumber(behind) > 0 then
          table.insert(parts, "󰜮 " .. behind)
        end
        
        return table.concat(parts, " ")
      end

      lualine.setup({
        options = {
          theme = "monokai-pro",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "NvimTree", "alpha", "dashboard", "aerial", "toggleterm" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 500, -- Faster refresh for better responsiveness
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                local mode_map = {
                  ["NORMAL"] = "󰰓 NORMAL",
                  ["INSERT"] = "󰰅 INSERT", 
                  ["VISUAL"] = "󰰤 VISUAL",
                  ["V-LINE"] = "󰰤 V-LINE",
                  ["V-BLOCK"] = "󰰤 V-BLOCK",
                  ["COMMAND"] = "󰰞 COMMAND",
                  ["REPLACE"] = "󰰟 REPLACE",
                  ["TERMINAL"] = "󰰬 TERMINAL",
                  ["SELECT"] = "󰰟 SELECT"
                }
                return mode_map[str] or "󰰓 " .. str:sub(1, 1)
              end,
              separator = { right = "" },
            },
            {
              macro_recording,
              color = { fg = "#ff6188", gui = "bold" },
              cond = function() return vim.fn.reg_recording() ~= "" end,
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "󰊢", -- Git branch icon
              color = { fg = "#a9dc76", gui = "bold" },
            },
            {
              "diff",
              symbols = { added = "󰐖 ", modified = "󰏬 ", removed = "󰍵 " },
              diff_color = {
                added = { fg = "#a9dc76" },
                modified = { fg = "#fc9867" },
                removed = { fg = "#ff6188" },
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed
                  }
                end
              end,
            },
            {
              git_unstaged_stats,
              color = { fg = "#fc9867" },
              cond = function()
                return vim.fn.isdirectory(".git") == 1
              end,
            },
            {
              git_commit_diff,
              color = { fg = "#78dce8" },
              cond = function()
                return vim.fn.isdirectory(".git") == 1
              end,
            },
            {
              search_count,
              color = { fg = "#78dce8" },
              cond = function()
                -- Only when actively typing a search
                local cmd = vim.fn.getcmdtype()
                if cmd ~= '/' and cmd ~= '?' then return false end
                if vim.v.hlsearch == 0 then return false end
                local pattern = vim.fn.getreg('/')
                if not pattern or pattern == '' or pattern == '\\%^' then return false end
                local found = vim.fn.searchpos(pattern, 'nw')
                return found[1] > 0 and found[2] > 0
              end,
            },
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = true,
              path = 1, -- Relative path
              shorting_target = 30,
              symbols = {
                readonly = "󰌾 ",
                unnamed = "󰡯 [No Name]",
                newfile = "󰎔 [New]",
              },
              color = { fg = "#fcfcfa", gui = "bold" },
            },
            {
              modified_indicator,
              color = { fg = "#fc9867", gui = "bold" },
            },
            {
              "filetype",
              colored = true,
              icon_only = false,
              icon = { align = "left" },
              color = { fg = "#ab9df2" },
            },
            {
              smart_file_size,
              color = { fg = "#78dce8" },
            },
          },
          lualine_x = {
            {
              python_venv,
              color = { fg = "#a9dc76", gui = "bold" },
              cond = function() return vim.bo.filetype == "python" end,
            },
            {
              lsp_status,
              color = { fg = "#ab9df2" },
            },
            {
              smart_diagnostics,
              color = function()
                local diagnostics = vim.diagnostic.get(0)
                for _, diagnostic in ipairs(diagnostics) do
                  if diagnostic.severity == vim.diagnostic.severity.ERROR then
                    return { fg = "#ff6188", gui = "bold" }
                  end
                end
                return { fg = "#a9dc76" }
              end,
            },
            {
              "encoding",
              fmt = string.upper,
              color = { fg = "#727072" },
              cond = function() return vim.bo.fileencoding ~= "utf-8" end,
            },
            {
              "fileformat",
              symbols = {
                unix = "󰌽 LF",
                dos = "󰌾 CRLF", 
                mac = "󰌼 CR",
              },
              color = { fg = "#727072" },
              cond = function() return vim.bo.fileformat ~= "unix" end,
            },
          },
          lualine_y = {
            {
              buffer_info,
              color = { fg = "#fc9867" },
            },
            {
              "progress",
              fmt = function(str) return "󰉸 " .. str end,
              color = { fg = "#78dce8" },
            },
            {
              "location",
              fmt = function(str) return "󰰤 " .. str end,
              color = { fg = "#fcfcfa", gui = "bold" },
            },
          },
          lualine_z = {
            {
              "datetime",
              style = "󰥔 %H:%M",
              color = { gui = "bold" },
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
                readonly = "󰌾 ",
                unnamed = "󰡯 [No Name]",
              },
              color = { fg = "#727072" },
            }
          },
          lualine_x = { 
            {
              "location",
              color = { fg = "#727072" },
            }
          },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "toggleterm", "fugitive", "aerial", "quickfix" },
      })
    end,
  },
}
