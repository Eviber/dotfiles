return {
	'lewis6991/gitsigns.nvim',
	version = "*",
	event = 'BufEnter *.*',
	config = function()
		require('gitsigns').setup()
	end,
	dependencies = {
		{ "ejrichards/baredot.nvim" },
	},
}
