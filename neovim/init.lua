-- Only to make diagnostics shut up
---@diagnostic disable-next-line: undefined-global
local vim = vim

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
local function concat(...)
  local result = {}

  for _, tab in pairs({ ... }) do
    for _, v in pairs(tab) do
      table.insert(result, v)
    end
  end

  return result
end
local function contains(tab, val)
  for i, v in pairs(tab) do
    if v == val then
      return i, v
    end
  end
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

-- Folding

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
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
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

  -- External tools
  'ActivityWatch/aw-watcher-vim',
  'github/copilot.vim', --

  -- Editor support
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-abolish',
  'tpope/vim-unimpaired',
  'AndrewRadev/tagalong.vim',
  'nvimtools/none-ls.nvim',
  { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig' },

  {
    'numToStr/Comment.nvim',
    opts = {}, lazy = false },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    config = function()
      local ts_configs = require('nvim-treesitter.configs')

      ts_configs.setup {
        ensure_installed = {
          'javascript', 'typescript', 'tsx', 'html', 'vue', 'graphql', 'jsdoc', 'css', 'scss', -- Frontend
          'c', 'cpp', 'rust', 'go', 'java',                                                    -- System
          'python', 'lua', 'bash', 'groovy', 'ruby',                                           -- Scripting
          'vim', 'vimdoc',                                                                     -- Vim
          'git_rebase', 'diff', 'gitcommit',                                                   -- Git
          'json', 'json5', 'yaml', 'make',                                                     -- Config/CI
          'markdown', 'markdown_inline', 'query', 'regex', 'sql', 'comment', 'beancount'       -- Other
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Completion
  { 'L3MON4D3/LuaSnip' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'saadparwaiz1/cmp_luasnip', 'L3MON4D3/LuaSnip' },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm {
            select = true,
          },
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'luasnip' },
        }),
      }
    end,
  },

  -- UI
  'stevearc/dressing.nvim',
  'psliwka/vim-smoothie',
  'tribela/vim-transparent',

  { 'petertriho/nvim-scrollbar', main = 'scrollbar' },

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
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
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

      telescope.setup {}
    end,
  },
}


-- LSP support
local function setup_lsp()
  local mason = require('mason')
  local mason_lspconfig = require('mason-lspconfig')
  local lspconfig = require('lspconfig')
  local null_ls = require('null-ls')

  local function organize_imports()
    local params = {
      command = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = ""
    }
    vim.lsp.buf.execute_command(params)
  end

  local lang_servers = {
    'lua_ls',
    'tsserver',
    'bashls',
    'jsonls',
    'pyright',
    'rust_analyzer',
    'tailwindcss',
    'vuels',
    'beancount',
  }

  local linters = {
    'eslint',
  }

  local extra = {
    'yamlls'
  }

  mason.setup()

  mason_lspconfig.setup {
    ensure_installed = concat(lang_servers, linters, extra),
  }

  lspconfig.yamlls.setup {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        },
      },
    },
  }

  local DENY_AUTO_SETUP = { 'beancount' }

  mason_lspconfig.setup_handlers {
    function(server_name)
      local server_config = lspconfig[server_name]

      local custom_setups = {
        beancount = {
          init_options = {
            journal_file = ""
          }
        }
      }

      if server_config then
        server_config.setup(custom_setups[server_name] or {
          commands = {
            OrganizeImports = {
              organize_imports,
              description = "Organize Imports",
            },
          }
        })
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
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
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
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
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

      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldenable = false
    end,
  })
end

setup_lsp()
lsp_keymaps()
