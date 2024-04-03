local DOTFILES_HOME = vim.env.DOTFILES_HOME or (vim.env.HOME .. '/dotfiles')

local function noop() end

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
  { 'numToStr/Comment.nvim' },
  {
    'RRethy/base16-nvim',
    lazy = false,
    config = function()
      require('base16-colorscheme').with_config({
          telescope = false,
      })
      vim.cmd('colorscheme base16-seti')
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local tele_builtins = require('telescope.builtin')

      vim.keymap.set('n', '<leader>ff', tele_builtins.find_files, {})
      vim.keymap.set('n', '<leader>fg', tele_builtins.live_grep, {})
      vim.keymap.set('n', '<leader>fb', tele_builtins.buffers, {})
      vim.keymap.set('n', '<leader>fh', tele_builtins.help_tags, {})

      telescope.setup {
        pickers = {
          find_files = {
            --find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
        },
      }
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    config = function()
      local ts_configs = require('nvim-treesitter.configs')

      ts_configs.setup {
        ensure_installed = { 'c', 'cpp', 'rust', 'go', 'lua', 'javascript', 'typescript', 'python', 'tsx', 'html', 'bash', 'vim', 'vimdoc', 'query', 'regex', 'sql', 'vue' },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end
  },

  { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig' },
  { 'github/copilot.vim' },
}


-- LSP support
require('mason').setup()
require("mason-lspconfig").setup {
  ensure_installed = { 'lua_ls', 'tsserver', 'bashls', 'pyright', 'rust_analyzer', 'tailwindcss', 'vuels' },
}
require("mason-lspconfig").setup_handlers {
  function (server_name)
    require("lspconfig")[server_name].setup {}
  end,
}

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Set noop defauts maps, to be overridden by LSP
vim.keymap.set('n', '<leader>rn', noop, {})
vim.keymap.set('n', '<leader>a', noop, {})
vim.keymap.set('n', '<leader>b', noop, {})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>b', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- wat is dis?
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  end,
})
