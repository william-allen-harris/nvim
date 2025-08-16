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
          numbers = "ordinal",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 18,
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 18,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
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
              text = "File Explorer",
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
          separator_style = "slant",
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
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
      
      -- Custom components for Python development
      local function python_venv()
        local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
        if venv then
          local venv_name = vim.fn.fnamemodify(venv, ":t")
          return "🐍 " .. venv_name
        end
        return ""
      end

      local function lsp_status()
        -- Use the most compatible way to get LSP clients
        local clients = {}
        
        -- Try the newer API first, then fall back to older versions
        if vim.lsp.get_clients then
          clients = vim.lsp.get_clients({ bufnr = 0 })
        elseif vim.lsp.get_active_clients then
          clients = vim.lsp.get_active_clients({ bufnr = 0 })
        elseif vim.lsp.buf_get_clients then
          clients = vim.lsp.buf_get_clients(0)
        end
        
        if #clients == 0 then
          return ""
        end
        
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        return "LSP: " .. table.concat(client_names, ", ")
      end

      local function diagnostics_count()
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
        if count.errors > 0 then table.insert(parts, "E:" .. count.errors) end
        if count.warnings > 0 then table.insert(parts, "W:" .. count.warnings) end
        if count.hints > 0 then table.insert(parts, "H:" .. count.hints) end
        if count.info > 0 then table.insert(parts, "I:" .. count.info) end
        
        return table.concat(parts, " ")
      end

      local function git_blame()
        local blame = vim.b.gitsigns_blame_line
        if blame and blame ~= "" then
          return "󰊢 " .. blame
        end
        return ""
      end

      local function file_size()
        local size = vim.fn.getfsize(vim.fn.expand("%:p"))
        if size < 0 then
          return ""
        elseif size < 1024 then
          return size .. "B"
        elseif size < 1024 * 1024 then
          return string.format("%.1fK", size / 1024)
        else
          return string.format("%.1fM", size / (1024 * 1024))
        end
      end

      local function macro_recording()
        local recording = vim.fn.reg_recording()
        if recording ~= "" then
          return "Recording @" .. recording
        end
        return ""
      end

      lualine.setup({
        options = {
          theme = "monokai-pro",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "NvimTree", "alpha", "dashboard" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
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
            {
              macro_recording,
              color = { fg = "#ff6188", gui = "bold" },
            },
          },
          lualine_b = {
            {
              "branch",R 
              icon = "",
            },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              diff_color = {
                added = { fg = "#a9dc76" },
                modified = { fg = "#fc9867" },
                removed = { fg = "#ff6188" },
              },
            },
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = false,
              path = 1, -- 0: filename, 1: relative path, 2: absolute path, 3: absolute path with ~ home
              shorting_target = 40,
              symbols = {
                modified = "●",
                readonly = "",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
            {
              "filetype",
              colored = true,
              icon_only = false,
              icon = { align = "right" },
            },
            {
              file_size,
              color = { fg = "#78dce8" },
            },
          },
          lualine_x = {
            {
              python_venv,
              color = { fg = "#a9dc76", gui = "bold" },
            },
            {
              lsp_status,
              color = { fg = "#ab9df2" },
            },
            {
              diagnostics_count,
              color = { fg = "#ff6188" },
            },
            {
              "encoding",
              fmt = string.upper,
            },
            {
              "fileformat",
              symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR",
              },
            },
          },
          lualine_y = {
            {
              "progress",
            },
            {
              "location",
            },
          },
          lualine_z = {
            {
              "datetime",
              style = "%H:%M",
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "toggleterm", "fugitive" },
      })
    end,
  },

  -- Git blame in virtual text (complementary to gitsigns)
  {
    "f-person/git-blame.nvim",
    event = "BufReadPost",
    config = function()
      vim.g.gitblame_enabled = 0 -- Start disabled, toggle with command
      vim.g.gitblame_message_template = "<summary> • <date> • <author>"
      vim.g.gitblame_highlight_group = "Comment"
      vim.g.gitblame_date_format = "%r"
      
      vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle git blame" })
    end,
  },
}
