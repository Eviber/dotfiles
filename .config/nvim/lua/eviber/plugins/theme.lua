return {
	'Shatur/neovim-ayu',
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.background = 'light'
		vim.cmd('colorscheme ayu')
	end
}

-- return {
-- 	'navarasu/onedark.nvim',
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd('colorscheme onedark')
-- 	end
-- }
