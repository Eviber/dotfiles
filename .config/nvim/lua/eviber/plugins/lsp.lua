-- suggest_lsp_servers
-- call_servers
-- sign_icons
-- state_file
-- set_lsp_keymaps
-- configure_diagnostics
-- cmp_capabilities
-- manage_nvim_cmp
-- manage_luasnip
-- setup_servers_on_start

-- local lsp = require('lsp-zero')
-- print(vim.inspect(lsp))

return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    lazy = false,
    config = function()
      -- This is where you modify the settings for lsp-zero
      -- Note: autocompletion settings will not take effect

      require('lsp-zero.settings').preset({
        name = 'recommended',
      })
    end
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      -- The arguments for .extend() have the same shape as `manage_nvim_cmp`: 
      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

      require('lsp-zero.cmp').extend({
        set_sources = 'recommended',
        set_basic_mappings = true,
        set_extra_mappings = false,
        use_luasnip = true,
        set_format = true,
        documentation_window = true,
      })

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()

      cmp.setup({
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        }
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(function() vim.cmd('MasonUpdate') end)
        end,
      },
	  {'simrat39/rust-tools.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp = require('lsp-zero')

      lsp.on_attach(function(_, bufnr)
        lsp.default_keymaps({buffer = bufnr})
      end)

      lsp.skip_server_setup({'rust_analyzer'})

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()

      local rust_tools = require('rust-tools')

      rust_tools.setup({
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<leader>vca', rust_tools.code_actions.code_actions_group, {buffer = bufnr})
            print("Rust tools loaded")
          end,
        }
      })
    end
  }
}
