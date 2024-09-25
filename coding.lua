-- coding.lua
return {
    -- Telescope: Fuzzy finder
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup{}
      end,
    },
  
    -- Treesitter: Syntax highlighting and code parsing
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = { "c", "lua", "python", "javascript" }, -- Add languages as needed
          highlight = { enable = true },
        }
      end,
    },
  
    -- LSP configuration for Neovim
    {
      'neovim/nvim-lspconfig',
      config = function()
        local lspconfig = require('lspconfig')
        lspconfig.pyright.setup{} -- Example for Python LSP
        lspconfig.tsserver.setup{} -- Example for JavaScript/TypeScript
      end,
    },
  
    -- Completion: Autocomplete
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
      },
      config = function()
        local cmp = require('cmp')
        cmp.setup {
          mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm { select = true },
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'buffer' },
          })
        }
      end,
    },
  
    -- Snippet engine
    {
      'L3MON4D3/LuaSnip',
      config = function()
        require('luasnip').setup{}
      end,
    },
  
    -- Git integration
    {
      'tpope/vim-fugitive',
      config = function()
        -- No additional config needed
      end,
    },
  
    -- Status line
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('lualine').setup{
          options = { theme = 'auto' },
        }
      end,
    },
  
    -- Git signs in gutter
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end,
    },
  
    -- Auto pairs for brackets and quotes
    {
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup{}
      end,
    },
  
    -- Comment toggling
    {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup{}
      end,
    },
  }
  