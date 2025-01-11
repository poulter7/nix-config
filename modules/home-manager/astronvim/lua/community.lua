-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.
if vim.g.vscode then
  return {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.recipes.vscode" },
    { import = "astrocommunity.motion.hop-nvim" },
  }
end

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.color.modes-nvim" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.motion.hop-nvim" },
  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.colorscheme.kanagawa-nvim", enabled = true },
  { import = "astrocommunity.completion.copilot-lua" },
  { import = "astrocommunity.completion.avante-nvim" },
  { import = "astrocommunity.note-taking.neorg" },
  { import = "astrocommunity.project.projectmgr-nvim" },
  -- { import = "astrocommunity.project.nvim-spectre" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.split-and-window.windows-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.julia" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.zig" },
  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.colorscheme.catppuccin" },
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
      --     -- run default AstroNvim nvim-dap-ui configuration function
      --     require "plugins.configs.nvim-dap-ui"(plugin, opts)
      --
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
}
