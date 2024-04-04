local DOTFILES_HOME = vim.env.DOTFILES_HOME or (vim.env.HOME .. '/dotfiles')

local function noop() end
local function merge(...)
  local result = {}

  for _, tab in pairs({ ... }) do
    for k, v in pairs(tab) do
      result[k] = v
    end
  end

  return result
end

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
vim.opt.cursorline = true

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

-- Disabling netrw, because of incompatible behavior with nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Mark bash as the default shell syntax
-- I'm already familiar with bashisms and I work in bashed sourced files most
-- of the time anyways
vim.g.is_bash = true

-- Clear selection being searched on Esc
vim.keymap.set('n', '<Esc>', '<cmd>noh<cr>')

local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " "
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-------------
-- Plugins --
-------------
vim.opt.rtp:prepend(DOTFILES_HOME .. '/neovim/lazy')

vim.g.transparent_groups_add = { 'GitGutterAdd', 'GitGutterChange', 'GitGutterDelete' }

require('lazy').setup {
  -- Theme
  {
    'RRethy/base16-nvim',
    lazy = false,
    priority = 100,
    config = function()
      require('base16-colorscheme').with_config({
          telescope = false,
      })

      vim.cmd.colorscheme('base16-seti')
      vim.cmd.highlight { 'CursorLineNr', 'guifg=NONE' }
    end
  },

  -- Editor support
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-abolish',
  'tpope/vim-unimpaired',
  'AndrewRadev/tagalong.vim',
  -- 'pocco81/auto-save.nvim',
  { 'numToStr/Comment.nvim', opts = {}, lazy = false },
  { 'windwp/nvim-autopairs', event = "InsertEnter", config = true },
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
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  { 'nvimtools/none-ls.nvim' },

  -- External tools
  'ActivityWatch/aw-watcher-vim',
  'github/copilot.vim', --
  'tribela/vim-transparent',

  -- UI
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()

      vim.keymap.set('n', '<leader>nf', '<cmd>NvimTreeFindFile<cr>')
      vim.keymap.set('n', '<leader>ne', '<cmd>NvimTreeOpen<cr>')
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
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
    end,
  },
}


-- LSP support
local function setup_lsp()
  local mason = require('mason')
  local mason_lspconfig = require('mason-lspconfig')
  local lspconfig = require('lspconfig')
  local null_ls = require('null-ls')

  local lang_servers = {
    'lua_ls',
    'tsserver',
    'bashls',
    'pyright',
    'rust_analyzer',
    'tailwindcss',
    'vuels',
  }

  local formatters = {
    'prettier',
  }

  local linters = {
    'eslint',
  }

  mason.setup()

  mason_lspconfig.setup {
    ensure_installed = merge(lang_servers, formatters, linters),
  }

  mason_lspconfig.setup_handlers {
    function (server_name)
      local server_config = lspconfig[server_name]

      if server_config then
        server_config.setup {}
      end
    end,
  }

  null_ls.setup {
    debug = true,
    sources = {
      null_ls.builtins.formatting.prettier,
    }
  }

end

local function lsp_keymaps()
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
        vim.lsp.buf.format()
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
end

setup_lsp()
lsp_keymaps()
