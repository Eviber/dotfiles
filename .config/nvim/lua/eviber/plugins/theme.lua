return {
	{
		"folke/tokyonight.nvim",
		version = "*",
		lazy = false,
		priority = 1000,
		config = function ()
			vim.cmd('colorscheme tokyonight')
		end
	},
	{ 'Shatur/neovim-ayu', lazy = true },
	{ 'navarasu/onedark.nvim', lazy = true },
}
