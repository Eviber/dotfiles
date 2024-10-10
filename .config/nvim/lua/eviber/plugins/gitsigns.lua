return {
	'lewis6991/gitsigns.nvim',
	config = function()
		require('gitsigns').setup()
	end,
	event = 'BufEnter *.*',
	dependencies = {
		{ "ejrichards/baredot.nvim" },
	},
}
