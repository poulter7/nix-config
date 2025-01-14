-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
vim.opt.clipboard = "unnamedplus"
vim.api.nvim_create_autocmd("VimEnter", {
  command = "WindowsEqualize",
})
vim.diagnostic.config { virtual_text = false }

require("dapui").setup()

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}
