return {
  "mfussenegger/nvim-dap-python",
  keys = {
    -- **Test-Related Key Mappings**
    {
      mode = "n",
      "<leader>dm",
      function() require("dap-python").test_method() end,
      desc = "Debug Test Method",
    },
    {
      mode = "n",
      "<leader>dc",
      function() require("dap-python").test_class() end,
      desc = "Debug Test Class",
    },
    -- **File-Related Key Mappings**
    {
      mode = "v",
      "<leader>df",
      function()
        require("dap-python").debug_selection()
      end,
      desc = "Debug Selection",
    },
  },
  config = function()
    require("dap-python").setup(vim.g.python3_host_prog)
    require("dap-python").test_runner = "pytest"
  end,
}
