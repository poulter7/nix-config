-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    "windows.nvim",
    opts = {
      ignore = {
        buftype = { "quickfix", "nofile" }, -- nofile is for neotest's main buffer
        filetype = { "NvimTree", "neo-tree", "undotree", "gundo" },
      },
    },
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "BufEnter" },
    opts = {
      smooth = false,
      hi = {
        fg = "#e98a00",
      },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup {
        preset = "ghost",
        hi = {
          background = "None",
        },
        options = {
          -- Show the source of the diagnostic.
          show_source = false,
          multilines = {
            enabled = true,
            always_show = false,
          },
          enable_on_insert = true,
        },
      }
    end,
  },
  {
    "smoka7/hop.nvim",
    opts = {},
    keys = {
      {
        "f",
        function() require("hop").hint_words { multi_windows = true } end,
        mode = { "n" },
        desc = "Hop hint words",
      },
      {
        "<S-f>",
        function() require("hop").hint_lines { multi_windows = true } end,
        mode = { "n" },
        desc = "Hop hint lines",
      },
      {
        "f",
        function() require("hop").hint_words { extend_visual = true } end,
        mode = { "v" },
        desc = "Hop hint words",
      },
      {
        "<S-f>",
        function() require("hop").hint_lines { extend_visual = true } end,
        mode = { "v" },
        desc = "Hop hint lines",
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-17",
                path = "/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home/",
              },
              {
                name = "JavaSE-21",
                path = "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/",
              },
            },
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<C-l>" } },
      panel = { enabled = false },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(plugin, opts)
      -- disable dap events that are created
      local dap = require "dap"

      -- dap.listeners.after.event_initialized["dapui_config"] = nil
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false },
          },
        },
      }
    end,
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          enabled = false,
        },
        basedpyright = {},
      },
    },
  },
  {
    "tadaa/vimade",
    -- default opts (you can partially set these or configure them however you like)
    opts = {
      -- Recipe can be any of 'default', 'minimalist', 'duo', and 'ripple'
      -- Set animate = true to enable animations on any recipe.
      -- See the docs for other config options.
      recipe = { "default", { animate = true } },
      ncmode = "buffers", -- use 'windows' to fade inactive windows
      fadelevel = 0.7, -- any value between 0 and 1. 0 is hidden and 1 is opaque.
      tint = {
        -- bg = { rgb = { 0, 0, 0 }, intensity = 0.3 }, -- adds 30% black to background
        -- fg = {rgb={0,0,255}, intensity=0.3}, -- adds 30% blue to foreground
        -- fg = { rgb = { 120, 120, 120 }, intensity = 0.5 }, -- all text will be gray
        -- sp = {rgb={255,0,0}, intensity=0.5}, -- adds 50% red to special characters
        -- you can also use functions for tint or any value part in the tint object
        -- to create window-specific configurations
        -- see the `Tinting` section of the README for more details.
      },

      -- Changes the real or theoretical background color. basebg can be used to give
      -- transparent terminals accurating dimming.  See the 'Preparing a transparent terminal'
      -- section in the README.md for more info.
      -- basebg = [23,23,23],
      basebg = "",
      -- prevent a window or buffer from being styled. You
      blocklist = {
        default = {
          highlights = {
            laststatus_3 = function(win, active)
              -- Global statusline, laststatus=3, is currently disabled as multiple windows take ownership
              -- of the StatusLine highlight (see #85).
              if vim.go.laststatus == 3 then
                -- you can also return tables (e.g. {'StatusLine', 'StatusLineNC'})
                return "StatusLine"
              end
            end,
            -- Exact highlight names are supported:
            -- 'WinSeparator',
            -- Lua patterns are supported, just put the text between / symbols:
            -- '/^StatusLine.*/' -- will match any highlight starting with "StatusLine"
          },
          buf_opts = { buftype = { "prompt" } },
          win_config = { relative = true },
          -- buf_name = {'name1','name2', name3'},
          -- buf_vars = { variable = {'match1', 'match2'} },
          -- win_opts = { option = {'match1', 'match2' } },
          -- win_vars = { variable = {'match1', 'match2'} },
        },
        -- any_rule_name1 = {
        --   buf_opts = {}
        -- },
        -- only_behind_float_windows = {
        --   buf_opts = function(win, current)
        --     if (win.win_config.relative == '')
        --       and (current and current.win_config.relative ~= '') then
        --         return false
        --     end
        --     return true
        --   end
        -- },
      },
      -- Link connects windows so that they style or unstyle together.
      -- Properties are matched against the active window. Same format as blocklist above
      link = {},
      groupdiff = true, -- links diffs so that they style together
      groupscrollbind = false, -- link scrollbound windows so that they style together.
      -- enable to bind to FocusGained and FocusLost events. This allows fading inactive
      -- tmux panes.
      enablefocusfading = false,
      -- Time in milliseconds before re-checking windows. This is only used when usecursorhold
      -- is set to false.
      checkinterval = 1000,
      -- enables cursorhold event instead of using an async timer.  This may make Vimade
      -- feel more performant in some scenarios. See h:updatetime.
      usecursorhold = false,
      -- when nohlcheck is disabled the highlight tree will always be recomputed. You may
      -- want to disable this if you have a plugin that creates dynamic highlights in
      -- inactive windows. 99% of the time you shouldn't need to change this value.
      nohlcheck = true,
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local dap_python = require "dap-python"
      local adapter_python_path = require("mason-registry").get_package("debugpy"):get_install_path()
        .. "/venv/bin/python"

      dap_python.setup(adapter_python_path)
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    branch = "regexp", -- This is the regexp branch, use this for the new version
    config = function() require("venv-selector").setup() end,
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
    {
      "akinsho/toggleterm.nvim",
      commit = "193786e0371e3286d3bc9aa0079da1cd41beaa62",
      opts = function(self, opts)
        opts.direction = "float"
        return opts
      end,
    },
    -- -- == Examples of Adding Plugins ==

    -- "andweeb/presence.nvim",
    -- {
    --   "ray-x/lsp_signature.nvim",
    --   event = "BufRead",
    --   config = function() require("lsp_signature").setup() end,
    -- },

    -- -- == Examples of Overriding Plugins ==

    -- -- customize alpha options
    -- {
    --   "goolord/alpha-nvim",
    --   opts = function(_, opts)
    --     -- customize the dashboard header
    --     opts.section.header.val = {
    --       " █████  ███████ ████████ ██████   ██████",
    --       "██   ██ ██         ██    ██   ██ ██    ██",
    --       "███████ ███████    ██    ██████  ██    ██",
    --       "██   ██      ██    ██    ██   ██ ██    ██",
    --       "██   ██ ███████    ██    ██   ██  ██████",
    --       " ",
    --       "    ███    ██ ██    ██ ██ ███    ███",
    --       "    ████   ██ ██    ██ ██ ████  ████",
    --       "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
    --       "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
    --       "    ██   ████   ████   ██ ██      ██",
    --     }
    --     return opts
    --   end,
    -- },

    -- -- You can disable default plugins as follows:
    -- { "max397574/better-escape.nvim", enabled = false },

    -- -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
    -- {
    --   "L3MON4D3/LuaSnip",
    --   config = function(plugin, opts)
    --     require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
    --     -- add more custom luasnip configuration such as filetype extend or custom snippets
    --     local luasnip = require "luasnip"
    --     luasnip.filetype_extend("javascript", { "javascriptreact" })
    --   end,
    -- },

    -- {
    --   "windwp/nvim-autopairs",
    --   config = function(plugin, opts)
    --     require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
    --     -- add more custom autopairs configuration such as custom rules
    --     local npairs = require "nvim-autopairs"
    --     local Rule = require "nvim-autopairs.rule"
    --     local cond = require "nvim-autopairs.conds"
    --     npairs.add_rules(
    --       {
    --         Rule("$", "$", { "tex", "latex" })
    --           -- don't add a pair if the next character is %
    --           :with_pair(cond.not_after_regex "%%")
    --           -- don't add a pair if  the previous character is xxx
    --           :with_pair(
    --             cond.not_before_regex("xxx", 3)
    --           )
    --           -- don't move right when repeat character
    --           :with_move(cond.none())
    --           -- don't delete if the next character is xx
    --           :with_del(cond.not_after_regex "xx")
    --           -- disable adding a newline when you press <cr>
    --           :with_cr(cond.none()),
    --       },
    --       -- disable for .vim files, but it work for another filetypes
    --       Rule("a", "a", "-vim")
    --     )
    --   end,
    -- },
    {
      "jsongerber/thanks.nvim",
      config = true,
    },
  },
}
