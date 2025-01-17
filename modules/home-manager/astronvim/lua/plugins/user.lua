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
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup {
        overrides = function() -- add/modify highlights
          return {
            BufferCurrent = { bg = "#e98a00", fg = "#000000" },
            BufferCurrentMod = { link = "BufferCurrent" },
          }
        end,
      }
    end,
  },
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
      "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = "^1.0.0", -- optional: only update when a new 1.x version is released
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
      fadelevel = 0.7, -- any value between 0 and 1. 0 is hidden and 1 is opaque.
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
      opts = function(opts)
        opts.direction = "float"
        return opts
      end,
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        opts.tabline = nil -- remove tabline
      end,
    },
    {
      "jsongerber/thanks.nvim",
      config = true,
    },
    { "sQVe/sort.nvim" },
  },
}
