-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use {
		'navarasu/onedark.nvim',
		config = function()
			vim.cmd('colorscheme onedark')
		end
	}

	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use 'mbbill/undotree'
	use 'tpope/vim-fugitive'

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{'williamboman/mason.nvim'},           -- Optional
			{'williamboman/mason-lspconfig.nvim'}, -- Optional

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},         -- Required
			{'hrsh7th/cmp-nvim-lsp'},     -- Required
			{'hrsh7th/cmp-buffer'},       -- Optional
			{'hrsh7th/cmp-path'},         -- Optional
			{'saadparwaiz1/cmp_luasnip'}, -- Optional
			{'hrsh7th/cmp-nvim-lua'},     -- Optional

			-- Snippets
			{'L3MON4D3/LuaSnip'},             -- Required
			{'rafamadriz/friendly-snippets'}, -- Optional
		}
	}

	use 'github/copilot.vim'
	-- use {
	-- 	"zbirenbaum/copilot.lua",
	-- 	cmd = "Copilot",
	-- 	config = function()
	-- 		require("copilot").setup({
	-- 			panel = {
	-- 				enabled = false,
	-- 				auto_refresh = true,
	-- 			},
	-- 			suggestion = {
	-- 				enabled = true,
	-- 				auto_trigger = true,
	-- 				keymap = {
	-- 					-- accept = "<Tab>",
	-- 				},
	-- 			},
	-- 			filetypes = {
	-- 				markdown = true,
	-- 				yaml = true,
	-- 			},
	-- 		})
	-- 	end,
	-- }

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup {
				sections = {
					lualine_x = {
						"copilot",
						"filetype",
						"fileformat",
						"encoding",
					}
				},
				options = { theme = 'onedark' }
			}
		end
	}
	use { "1478zhcy/lualine-copilot" }

	use 'ap/vim-css-color'

	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end
	}

	use 'tpope/vim-commentary'

	use 'MunifTanjim/prettier.nvim'

	use 'p00f/clangd_extensions.nvim'
	use 'simrat39/rust-tools.nvim'

end)
