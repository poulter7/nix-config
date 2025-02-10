-- buffer pick
require('Comment').setup {
  toggler = {
    line = '<Leader>cc',
    block = '<Leader>cb',
  },
  opleader = {
    line = '<Leader>cc',
    block = '<Leader>cb',
  },
}

-- dap settings
vim.o.switchbuf = 'useopen,uselast'
-- column settings
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes:1'
vim.opt.cmdheight = 0

--- keybindings
local tele = require 'telescope.builtin'
local nx = { 'n', 'x' }
local nv = { 'n', 'v' }

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd [[cab cc CodeCompanion]]
require('which-key').add {
  --
  { '<C-h>', require('smart-splits').move_cursor_left },
  { '<C-j>', require('smart-splits').move_cursor_down },
  { '<C-k>', require('smart-splits').move_cursor_up },
  { '<C-l>', require('smart-splits').move_cursor_right },
  { '-', '<Cmd>split<CR>' },
  { '|', '<Cmd>vsplit<CR>' },
  { '<C-w>=', '<Cmd>WindowsEqualize<CR>' },
  { '<C-w>+', '<Cmd>WindowsMaximize<CR>' },
  -- CodeCompanion
  { '<C-a>', '<Cmd>CodeCompanionActions<CR>' },
  { '<Leader>a', '<Cmd>CodeCompanionChat Toggle<CR>' },
  { 'ga', '<Cmd>CodeCompanionChat<CR>' },
  -- Trouble
  { '<leader>x', group = '[X]Trouble', mode = nx },
  {
    '<leader>xx',
    '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
    desc = 'Diagnostics',
  },
  { '<leader>xq', '<Cmd>Trouble qflist toggle<Cr>', desc = '[X]Trouble Quickfix' },
  {
    '<leader>xX',
    '<cmd>Trouble diagnostics toggle<cr>',
    desc = 'Diagnostics (Workspace)',
  },
  --- toggle term
  { '\\', '<Cmd>execute v:count . "ToggleTerm"<CR>' },
  { '\\', '<Cmd>ToggleTerm<CR>', mode = 't' },
  -- code
  { '<leader>c', group = '[C]ode', mode = nx },
  { '<leader>r', group = '[R]est', mode = nx },
  { '<leader>rr', '<Cmd>Rest run<CR>', desc = '[R]est [R]un' },
  { '<leader>a', group = '[A]rrow', mode = nx },
  { '<Leader>cv', '<cmd>VenvSelect<cr>' },
  { '<leader>u', group = '[U]ser Interface' },
  { '<leader>ut', '<Cmd>Neotest summary<CR>', desc = 'UI: toggle neotest summary' },
  { '<leader>b', group = '[B]uffers' },
  { '<leader>bp', '<Cmd>BufferPick<CR>', desc = '[B]uffer [P]ick' },
  { '<leader>bx', '<Cmd>BufferPickDelete<CR>', desc = '[B]uffer to [x]' },
  { '<leader>f', group = '[F]ind' },
  { '<leader>fe', '<Cmd>lua Snacks.explorer()<CR>', desc = '[F]ind t[E]lescope', silent = true },
  {
    '<leader>fk',
    function()
      Snacks.picker.keymaps()
    end,
    desc = '[F]ind [K]eymaps',
  },
  {
    '<leader>ff',
    function()
      Snacks.picker.files()
    end,
    desc = '[F]ind [F]iles',
  },
  {
    '<leader>fw',
    function()
      Snacks.picker.grep()
    end,
    desc = '[F]ind by [w]ord (Grep)',
  },
  {
    '<leader>fo',
    function()
      Snacks.picker.recent { filter = { cwd = true } }
    end,
    desc = '[F]ind [O]ld files',
  },
  {
    '<leader>fO',
    function()
      Snacks.picker.recent()
    end,
    desc = '[F]ind [O]ld files from everywhere',
  },
  {
    '<leader>f.',
    function()
      Snacks.picker.resume()
    end,
    desc = '[F]ind Recent Files ("." for repeat)',
  },
  {
    '<leader>/',
    function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      tele.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end,
    desc = '[/] Fuzzily search in current buffer',
  },
  -- Open in the current file's parent
  {
    '<leader>f-',
    '<cmd>Yazi<cr>',
    mode = nv,
    desc = '[F]ind using [Y]azi',
  },
  {
    '<leader>f_', -- Open in the current working directory
    '<cmd>Yazi cwd<cr>',
    desc = '[F]ind using [Y]azi in the cwd',
  },
  -- Debug
  { '<leader>d', group = '[D]ebug' },
  -- Debug: Start/Stop
  { '<leader>dm', '<Cmd>lua require("neotest").run.run { strategy = "dap" }<CR>', desc = '[D]ebug: [M]ethod (neotest)' },
  { '<leader>dc', '<Cmd>lua require("dap").continue()<CR>', desc = '[D]ebug: [C]ontinue' },
  { '<leader>dt', '<Cmd>lua require("dap").terminate()<CR>', desc = '[D]ebug: [T]erminate' },
  -- Debug: Breakpoints
  { '<leader>db', '<Cmd>lua require("persistent-breakpoints.api").toggle_breakpoint()<CR>', desc = '[D]ebug: [B]reakpoint' },
  { '<leader>dX', '<Cmd>lua require("persistent-breakpoints.api").clear_all_breakpoints()<CR>', desc = '[D]ebug: [X]clear all breakpoints' },
  -- Debug: UIs
  { '<leader>du', '<Cmd>lua require("dapui").toggle()<CR>', desc = '[D]ebug: UI' },
  { '<leader>dv', '<Cmd>lua require("dap-view").toggle()<CR>', desc = 'dap-view toggle' },
  { '<Bs>', '<Cmd>DapToggleRepl<CR>', desc = '[D]ebug: repl' },
  -- Debug: Step
  { '<leader>ds', group = '[D]ebug: [S]tep' },
  { '<leader>dsi', '<Cmd>lua require("dap").step_into()<CR>', desc = '[D]ebug: [S]tep [I]nto' },
  { '<leader>dso', '<Cmd>lua require("dap").step_over()<CR>', desc = '[D]ebug: [S]tep [O]ver' },
  { '<leader>dsO', '<Cmd>lua require("dap").step_out()<CR>', desc = '[D]ebug: [S]tep [O]ut' },
  -- Aider
  { '<leader>ua', '<Cmd>lua _aider_toggle()<CR>', desc = 'ToggleTerm aider' },
  -- Hop
  {
    'f',
    function()
      require('hop').hint_words { multi_windows = true }
    end,
    mode = { 'n' },
    desc = 'Hop hint words',
  },
  {
    '<S-f>',
    function()
      require('hop').hint_lines { multi_windows = true }
    end,
    mode = { 'n' },
    desc = 'Hop hint lines',
  },
  {
    'f',
    function()
      require('hop').hint_words { extend_visual = true }
    end,
    mode = { 'v' },
    desc = 'Hop hint words',
  },
  {
    '<S-f>',
    function()
      require('hop').hint_lines { extend_visual = true }
    end,
    mode = { 'v' },
    desc = 'Hop hint lines',
  },
}

local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new {
  cmd = 'lazygit',
  dir = 'git_dir',
  direction = 'float',
  float_opts = {
    border = 'double',
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd 'startinsert!'
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function()
    vim.cmd 'startinsert!'
  end,
}

function _lazygit_toggle()
  lazygit:toggle()
end

-- set resession to work within a directory
local resession = require 'resession'
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Only load the session if nvim was started with no args and without reading from stdin
    if vim.fn.argc(-1) == 0 and not vim.g.using_stdin then
      -- Save these to a different directory, so our manual sessions don't get polluted
      resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
    end
  end,
  nested = true,
})
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
  end,
})
vim.api.nvim_create_autocmd('StdinReadPre', {
  callback = function()
    -- Store this for later
    vim.g.using_stdin = true
  end,
})

-- Arrow handlers to get buffer -> line -> hop functionality
vim.api.nvim_create_autocmd('User', {
  pattern = 'ArrowOpenFile',
  callback = function(e)
    vim.schedule(function()
      local bfr = vim.api.nvim_get_current_buf()
      local bookmarks = require('arrow.buffer_persist').get_bookmarks_by(bfr)
      if #bookmarks > 0 then
        require('arrow.buffer_ui').openMenu(bfr)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'dap-view', 'dap-view-term', 'dap-repl', 'rest_nvim_result' }, -- dap-repl is set by `nvim-dap`
  callback = function(evt)
    vim.keymap.set('n', 'q', '<C-w>q', { silent = true, buffer = evt.buf })
  end,
})

local function merge(a, b)
  local _t = {}
  for k, v in pairs(a) do
    _t[k] = v
  end
  for k, v in pairs(b) do
    _t[k] = v
  end
  return _t
end

-- Post-init - override default colors
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd.colorscheme 'kanagawa'
    local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
    local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'bg'
    local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#3399ff', bg = sign_column_bg })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#9ece6a', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#FFFF00' })
    vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#f09000' })
    vim.api.nvim_set_hl(0, 'WarningMsg', merge(vim.api.nvim_get_hl(0, { name = 'WarningMsg' }), { bg = sign_column_bg }))
    vim.api.nvim_set_hl(0, 'ErrorMsg', merge(vim.api.nvim_get_hl(0, { name = 'ErrorMsg' }), { bg = sign_column_bg }))
    vim.api.nvim_set_hl(0, 'DiagnosticHint', merge(vim.api.nvim_get_hl(0, { name = 'DiagnosticHint' }), { bg = sign_column_bg }))
    vim.api.nvim_set_hl(0, 'DiagnosticInfo', merge(vim.api.nvim_get_hl(0, { name = 'DiagnosticInfo' }), { bg = sign_column_bg }))
    vim.api.nvim_set_hl(0, 'ArrowBookmarkSign', merge(vim.api.nvim_get_hl(0, { name = 'ArrowBookmarkSign' }), { fg = '#32CD32', bg = sign_column_bg }))

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

    -- don't display diagnostic text, just highlight the numbers
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '!',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.INFO] = '',
          [vim.diagnostic.severity.HINT] = '',
        },
        numhl = {
          [vim.diagnostic.severity.WARN] = 'WarningMsg',
          [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
          [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
          [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        },
      },
    }
  end,
})
return {}
