-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local function list_insert_unique(dst, src)
  if not dst then
    dst = {}
  end
  local added = {}
  for _, val in ipairs(dst) do
    added[val] = true
  end
  for _, val in ipairs(src) do
    if not added[val] then
      table.insert(dst, val)
      added[val] = true
    end
  end
  return dst
end

local function get_folder_if_exists(path)
  return vim.uv.fs_stat(path) and path or nil
end

return {
  {
    'mrjones2014/smart-splits.nvim',
  },
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = true,
  },
  {
    'stevearc/resession.nvim',
    opts = {},
  },
  {
    'akinsho/toggleterm.nvim',
    commit = '193786e0371e3286d3bc9aa0079da1cd41beaa62',
    opts = function(opts)
      opts.direction = 'float'
      return opts
    end,
  },
  {
    'tadaa/vimade',
    -- default opts (you can partially set these or configure them however you like)
    opts = {
      fadelevel = 0.7, -- any value between 0 and 1. 0 is hidden and 1 is opaque.
    },
  },
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
    opts = {
      ignore = {
        buftype = { 'quickfix', 'nofile' }, -- nofile is for neotest's main buffer
        filetype = { 'NvimTree', 'neo-tree', 'undotree', 'gundo' },
      },
    },
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 10000,
    config = function()
      --set colorscheme
      require('kanagawa').setup {
        overrides = function() -- add/modify highlights
          return {
            BufferCurrent = { bg = '#e98a00', fg = '#000000' },
            BufferCurrentMod = { link = 'BufferCurrent' },
          }
        end,
      }
    end,
  },
  -- co-pilot will rot your brain
  -- {
  --   'zbirenbaum/copilot.lua',
  --   opts = {
  --     suggestion = { enabled = true, auto_trigger = true, keymap = { accept = '<C-Enter>' } },
  --     panel = { enabled = false },
  --   },
  -- },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false, console = 'integratedTerminal' },
            args = { '-s', '--no-header', '--disable-warnings', '-qq' },
            runner = 'pytest',
          },
        },
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
  },
  {
    'neovim/nvim-lspconfig',
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
    'nvim-zh/colorful-winsep.nvim',
    config = true,
    event = { 'BufEnter' },
    opts = {
      smooth = false,
      hi = {
        fg = '#e98a00',
      },
    },
  },
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons', -- TODO: not working OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {},
    version = '^1.0.0',
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy', -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      vim.diagnostic.config { virtual_text = false }
      require('tiny-inline-diagnostic').setup {
        preset = 'modern',
        transparent_bg = false,
        hi = {
          background = 'None',
        },
        options = {
          -- Show the source of the diagnostic.
          show_all_diags_on_cursorline = false,
          virt_texts = {
            -- Priority for virtual text display
            priority = 4098,
          },
          enable_on_insert = false,
        },
      }
    end,
  },
  {
    'smoka7/hop.nvim',
    opts = {},
  },
  {
    'rebelot/heirline.nvim',
    opts = function(_, opts)
      opts.tabline = nil -- remove tabline
    end,
  },
  {
    'jsongerber/thanks.nvim',
    config = true,
  },
  { 'sQVe/sort.nvim' },
  { 'mistweaverco/kulala.nvim', opts = {} },
  {
    '0x00-ketsu/autosave.nvim',
    enabled = vim.fn.getcwd() ~= '/Users/jonathan/Code/projects/nix-config',
    -- lazy-loading on events
    event = { 'InsertLeave', 'TextChanged' },
    config = function()
      require('autosave').setup {}
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    config = function()
      local dap_python = require 'dap-python'
      local adapter_python_path = require('mason-registry').get_package('debugpy'):get_install_path() .. '/venv/bin/python'

      dap_python.setup(adapter_python_path, {
        console = 'integratedTerminal',
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim', -- use mason-lspconfig to configure LSP installations
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = list_insert_unique(opts.ensure_installed, {
        'lua_ls',
        'basedpyright',
        -- add more arguments for adding more language servers
      })
    end,
  },
  {
    'uga-rosa/ccc.nvim',
    event = 'FileType',
    keys = {
      { '<Leader>mc', '<cmd>CccPick<CR>', desc = 'Color-picker' },
    },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
        excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
      },
    },
  },
  {
    'jay-babu/mason-null-ls.nvim', -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
    -- overrides `require("mason-null-ls").setup(...)`
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
    },
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = list_insert_unique(opts.ensure_installed, {
        'prettier',
        'stylua',
        -- add more arguments for adding more null-ls sources
      })
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = list_insert_unique(opts.ensure_installed, {
        'python',
        -- add more arguments for adding more debuggers
      })
    end,
  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python', --optional
      { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    lazy = false,
    branch = 'regexp', -- This is the regexp branch, use this for the new version
    config = function()
      require('venv-selector').setup()
    end,
  },
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'poulter7/arrow.nvim',
    dir = get_folder_if_exists '/Users/jonathan/Code/projects/arrow.nvim/',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      -- or if using `mini.icons`
      -- { "echasnovski/mini.icons" },
    },
    opts = {
      show_icons = true,
      leader_key = '\t', -- Recommended to be a single key
      buffer_leader_key = '<S-\t>', -- Per Buffer Mappings
      index_keys = 'fjdksla;zxcvnm,.',
      mappings = {
        edit = 'E',
        delete_mode = 'D',
        clear_all_items = 'C',
        toggle = 'S', -- used as save if separate_save_and_remove is true
        open_vertical = 'V',
        open_horizontal = '-',
        quit = 'q',
        remove = 'X', -- only used if separate_save_and_remove is true
        next_item = ']',
        prev_item = '[',
      },
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { -- optional cmp completion source for require statements and module annotations
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        opts = {
          theme = 'gruvbox',
        },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
    },
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      adapters = {
        hosted = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'http://127.0.0.1:8080',
              api_key = 'key',
              chat_url = '/v1/chat/completions',
            },
          })
        end,
      },
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = 'hosted',
        },
      },
      opts = {
        -- Set debug logging
        log_level = 'DEBUG',
      },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },
}
