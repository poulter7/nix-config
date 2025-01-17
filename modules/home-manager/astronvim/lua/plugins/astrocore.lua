-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- auto start from directory session
    autocmds = {
      -- disable alpha autostart
      alpha_autostart = false,
      restore_session = {
        {
          event = "VimEnter",
          desc = "Restore previous directory session if neovim opened with no arguments",
          nested = true, -- trigger other autocommands as buffers open
          callback = function()
            -- Only load the session if nvim was started with no args
            if vim.fn.argc(-1) == 0 then
              -- try to load a directory session using the current working directory
              require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            end
          end,
        },
      },
    },
    -- Configure core features of AstroNvim
    features = {
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      underline = true,
      virtual_text = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175", -- sets vim.opt.guicursor
        number = true, -- sets vim.opt.number
        relativenumber = true, -- sets vim.opt.relativenumber
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        spell = false, -- sets vim.opt.spell
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        ["\\"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" },
        ["-"] = { ":split<cr>", desc = "Split" },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>bb"] = { "<Cmd>BufferPick<CR>", desc = "Select buffer from barbar" },
        ["<Leader>bD"] = { "<Cmd>BufferPickDelete<CR>", desc = "Select buffer from barbar to close" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
        ["<C-w>="] = { "<Cmd>WindowsEqualize<CR>", desc = "WindowsEqualize" },
        ["<C-w>+"] = { "<Cmd>WindowsMaximize<CR>", desc = "WindowsMaximize" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
        ["\\"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      },
    },
  },
}
