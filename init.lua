local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug 'github/copilot.vim'
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'navarasu/onedark.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'ap/vim-css-color'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'williamboman/nvim-lsp-installer'
Plug 'ms-jpq/coq_nvim'
vim.call('plug#end')

vim.opt.compatible = false
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = { tab = '‣ ', trail = '·', precedes = '«', extends = '»' }
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.api.nvim_command('filetype plugin on')
vim.api.nvim_command('filetype indent on')

require('onedark').load()
require('lualine').setup()

-- local lsp_installer = require('nvim-lsp-installer')

-- -- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- -- or if the server is already installed).
-- lsp_installer.on_server_ready(function(server)
-- 	local opts = {}

-- 	-- (optional) Customize the options passed to the server.
-- 	-- if server.name == "tsserver" then
-- 	-- 	opts.root_dir = function() ... end
-- 	-- end

-- 	-- This setup() function will take the provided server configuration and decorate it with the necessary properties
-- 	-- before passing it onwards to lspconfig.
-- 	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server-configurations.md
-- 	server:setup(opts)
-- end)
