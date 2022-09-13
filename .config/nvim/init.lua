local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug 'github/copilot.vim'
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'navarasu/onedark.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug '1478zhcy/lualine-copilot'
Plug 'ap/vim-css-color'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
-- Plug 'weilbith/nvim-lsp-smag'

-- Plug 'ms-jpq/coq_nvim'
-- Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/prettier.nvim'

Plug 'p00f/clangd_extensions.nvim'
Plug 'simrat39/rust-tools.nvim'
vim.call('plug#end')

vim.opt.compatible = false
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = { tab = '| ', trail = '·', precedes = '«', extends = '»' }
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.api.nvim_command('filetype plugin on')
vim.api.nvim_command('filetype indent on')

require('onedark').load()
require('lualine').setup {
	sections = {
		lualine_x = {
			"copilot",
			"filetype",
			"fileformat",
			"encoding",
		}
	}
}

-- Rust stuff
vim.g.rustfmt_autosave = 1
vim.g.rust_format_show_errors = 1
vim.g.rust_format_show_errors_delay = 0
vim.g.rust_fold = 1

require('prettier').setup({
		bin = 'prettier',
		filetypes = {
			"css",
			"graphql",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"less",
			"markdown",
			"scss",
			"typescript",
			"typescriptreact",
			"yaml",
		}
	})

-- setup lsp
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "rust_analyzer", "clangd", }
})

-- mappings.
-- see `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<M-l>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<M-l>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<M-l>wl', function()
    -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  -- vim.keymap.set('n', 'zD', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'zrn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'zca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<M-l>f', vim.lsp.buf.formatting, bufopts)
end

local nvim_lsp = require('lspconfig')

nvim_lsp['sumneko_lua'].setup {
    -- ... other configs
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

nvim_lsp['clangd'].setup{}
require("clangd_extensions").setup ({
		server = {
			on_attach = on_attach,
		}
	})
require("rust-tools").setup ({
		server = {
			on_attach = on_attach,
		}
	})

-- disable Copilot by default
vim.api.nvim_set_var('copilot_enabled', false)
vim.api.nvim_set_var('copilot_filetypes', { markdown = true })
-- set a toggle key for Copilot
vim.api.nvim_set_keymap('n', '<leader>c', ':lua vim.api.nvim_set_var("copilot_enabled", not vim.api.nvim_get_var("copilot_enabled"))<CR>', { noremap = true, silent = true })
