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
    'benlubas/molten-nvim',
    version = '^1.0.0', -- use version <2.0.0 to avoid breaking changes
    lazy = true,
    event = 'VeryLazy',
    ft = { 'python' },
    -- dependencies = {
    --   '3rd/image.nvim',
    --   lazy = true,
    --   event = 'VeryLazy',
    --   opts = {
    --     backend = 'kitty', -- whatever backend you would like to use
    --     max_width = 500,
    --     max_height = 40,
    --     max_height_window_percentage = math.huge,
    --     max_width_window_percentage = math.huge,
    --     window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
    --     window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    --   },
    -- },
    build = ':UpdateRemotePlugins',
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 100
      vim.g.molten_image_provider = 'image.nvim'
    end,
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
    },
    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default', ['<Tab>'] = { 'select_and_accept', 'fallback' } },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            transform_items = function(_, items)
              local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = 'Copilot'
              for _, item in ipairs(items) do
                item.kind = kind_idx
              end
              return items
            end,
            async = true,
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      require('ufo').setup {
        provider_selector = function(bufnr, filetype)
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },
  -- {
  --   'nvim-neorg/neorg',
  --   lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  --   version = '*', -- Pin Neorg to the latest stable release
  --   ft = { 'neorg' },
  --   config = {
  --     load = {
  --       ['core.defaults'] = {},
  --       ['core.concealer'] = {},
  --       ['core.summary'] = {},
  --     },
  --   },
  -- },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  -- {
  --   'ggandor/leap.nvim',
  --
  --
  --   opts = {},
  -- },
  {
    'smoka7/hop.nvim',
    version = '*',
    opts = {
      keys = 'arstgoienmwfpluykd',
    },
  },
  { 'echasnovski/mini.files', version = '*', opts = {} },
  {
    'swaits/zellij-nav.nvim',
    lazy = true,
    event = 'VeryLazy',
    keys = {
      { '<c-h>', '<cmd>ZellijNavigateLeftTab<cr>', { silent = true, desc = 'navigate left or tab' } },
      { '<c-j>', '<cmd>ZellijNavigateDown<cr>', { silent = true, desc = 'navigate down' } },
      { '<c-k>', '<cmd>ZellijNavigateUp<cr>', { silent = true, desc = 'navigate up' } },
      { '<c-l>', '<cmd>ZellijNavigateRightTab<cr>', { silent = true, desc = 'navigate right or tab' } },
    },
    opts = {},
  },
  {
    'caliguIa/zendiagram.nvim',
    opts = {
      -- Below are the default values
      header = '', -- Header text
      style = 'default', -- Float window style - 'default' | 'compact'
      max_width = 50, -- The maximum width of the float window
      min_width = 25, -- The minimum width of the float window
      max_height = 10, -- The maximum height of the float window
      position = {
        row = 1, -- The offset from the top of the screen
        col_offset = 2, -- The offset from the right of the screen
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {},
  },
  {
    'mrjones2014/smart-splits.nvim',
  },
  {
    'f-person/git-blame.nvim',
    opts = {
      date_format = '%r',
    },
  },
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = true,
  },
  {
    'chomosuke/typst-preview.nvim',
    event = 'VeryLazy',
    ft = 'typst',
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  },
  {
    'stevearc/resession.nvim',
    opts = {},
  },
  {
    'akinsho/toggleterm.nvim',
    commit = '193786e0371e3286d3bc9aa0079da1cd41beaa62',
    opts = {
      direction = 'float',
      start_in_insert = true,
      persist_mode = false,
      on_open = function()
        vim.cmd 'startinsert'
      end,
    },
  },
  {
    'bassamsdata/namu.nvim',
    dir = get_folder_if_exists '/Users/jonathan/Code/projects/namu.nvim/',
    config = function()
      require('namu').setup {
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {}, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        colorscheme = {
          enable = false,
          options = {
            -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
            persist = true, -- very efficient mechanism to Remember selected colorscheme
            write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
          },
        },
        ui_select = { enable = false }, -- vim.ui.select() wrapper
      }
      -- === Suggested Keymaps: ===
    end,
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
    opts = {
      overrides = function() -- add/modify highlights
        return {
          LineNr = { fg = '#808080' },
          BufferCurrent = { bg = '#e98a00', fg = '#000000' },
          BufferCurrentMod = { link = 'BufferCurrent' },
        }
      end,
    },
  },
  {
    'zbirenbaum/copilot.lua',
    enabled = false,
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
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
            dap = { justMyCode = false, console = 'internalConsole' },
            args = { '-s', '--no-header', '--disable-warnings', '-qq' },
            runner = 'pytest',
          },
        },
      }
    end,
  },
  {
    'chrisgrieser/nvim-early-retirement',
    config = true,
    event = 'VeryLazy',
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
    lazy = true,
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
    event = 'LspAttach', -- Or `LspAttach`
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
    'rebelot/heirline.nvim',
    opts = function(_, opts)
      opts.tabline = nil -- remove tabline
    end,
  },
  {
    'jsongerber/thanks.nvim',
    config = true,
    event = 'VeryLazy',
  },
  { 'sQVe/sort.nvim', event = 'VeryLazy' },
  { 'mistweaverco/kulala.nvim', opts = {} },
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
    lazy = true,
    event = 'VeryLazy',
    branch = 'regexp', -- This is the regexp branch, use this for the new version
    config = function()
      require('venv-selector').setup {
        settings = {
          search = {
            micromamba = {
              command = "fd -t f -t l 'python$' ~/micromamba/envs",
              type = 'anaconda',
            },
          },
        },
      }
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
    'poulter7/arrow.nvim',
    dir = get_folder_if_exists '/Users/jonathan/Code/projects/arrow.nvim/',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
    },
    opts = {
      show_icons = true,
      leader_key = '\t', -- Recommended to be a single key
      buffer_leader_key = '<S-\t>', -- Per Buffer Mappings
      index_keys = 'fjkslazxcvnm',
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
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'codedark',
        },
        sections = {
          lualine_b = { 'diff', 'diagnostics' },
          lualine_c = {
            function()
              return vim.fs.basename(vim.fn.getcwd())
            end,
            'filename',
          },
          lualine_x = { { require('gitblame').get_current_blame_text, cond = require('gitblame').is_blame_text_available } },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      routes = {
        {
          filter = {
            event = 'msg_show',
            kind = '',
            find = 'written',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            kind = '',
            find = 'Autosave',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            kind = '',
            find = 'change',
          },
          opts = { skip = true },
        },
      },
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
    'vhyrro/luarocks.nvim',
    opts = {
      rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' }, -- Specify LuaRocks packages to install
    },
  },
  {
    'rest-nvim/rest.nvim',
    event = { 'VeryLazy' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
    },
  },
  -- {
  --   'olimorris/codecompanion.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  --   opts = {
  --     adapters = {
  --       hosted = function()
  --         return require('codecompanion.adapters').extend('openai_compatible', {
  --           env = {
  --             url = 'http://127.0.0.1:8080',
  --             api_key = 'key',
  --             chat_url = '/v1/chat/completions',
  --           },
  --         })
  --       end,
  --     },
  --     strategies = {
  --       -- Change the default chat adapter
  --       chat = {
  --         adapter = 'hosted',
  --       },
  --     },
  --     opts = {
  --       -- Set debug logging
  --       log_level = 'DEBUG',
  --     },
  --   },
  -- },
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
