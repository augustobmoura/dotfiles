local DOTFILES_HOME = vim.env.DOTFILES_HOME or (vim.env.HOME .. '/dotfiles')

-------------
-- Options --
-------------
-- Editor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.backup = true
vim.opt.encoding = 'UTF-8'
vim.opt.foldlevel = 30
vim.opt.mouse = 'a'
vim.opt.expandtab = true

-- Colors
vim.opt.termguicolors = true

-- Invisibles
vim.opt.list = true
vim.opt.listchars = {
  tab = '»─',
  extends = '›',
  precedes = '‹',
  nbsp = '·',
  trail = '·',
  space = '·',
}
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Mark bash as the default shell syntax
-- I'm already familiar with bashisms and I work in bashed sourced files most
-- of the time anyways
vim.g.is_bash = true

-- Clear selection being searched on Esc
vim.keymap.set('n', '<Esc>', '<cmd>noh<cr>')


-------------
-- Plugins --
-------------
vim.opt.rtp:prepend(DOTFILES_HOME .. '/neovim/lazy')

require('lazy').setup {
  {
    'RRethy/base16-nvim',
    lazy = false,
    config = function()
      vim.cmd('colorscheme base16-seti')
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local ts_configs = require('nvim-treesitter.configs')

      ts_configs.setup {
        ensure_installed = { 'c', 'cpp', 'rust', 'go', 'lua', 'javascript', 'typescript', 'python', 'tsx', 'html', 'bash', 'vim', 'vimdoc', 'query', 'regex', 'sql', 'vue' },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },  
      }
    end
  }
}

