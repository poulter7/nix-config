return {
  "mfussenegger/nvim-dap-python",
  keys = {
    -- **Test-Related Key Mappings**
    {
      mode = "n",
      "<leader>dm",
      function() require("neotest").run.run { strategy = "dap" } end,
      desc = "Debug Test",
    },
    {
      mode = "n",
      "<leader>dM",
      function() require("dap-python").test_class() end,
      desc = "Debug Test Class",
    },
    -- **File-Related Key Mappings**
    {
      mode = "v",
      "<leader>df",
      function() require("dap-python").debug_selection() end,
      desc = "Debug Selection",
    },
    {
      mode = "n",
      "<leader>v",
      function() require("dap-view").toggle() end,
      desc = "dap-view toggle",
    },
    {
      mode = "n",
      "<leader>da",
      function() require("dap-view").add_expr() end,
      desc = "dap-view add expression",
    },
  },
  config = function()
    require("dap-python").setup(vim.g.python3_host_prog)
    require("dap-python").test_runner = "pytest"
  end,
}
