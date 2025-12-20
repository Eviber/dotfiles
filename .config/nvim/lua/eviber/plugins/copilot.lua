local copilot = {
	'github/copilot.vim',
	event = 'VeryLazy',
	config = function()
		vim.g.copilot_filetypes = {
			['markdown'] = 1,
		}

		vim.cmd('Copilot disable')
	end,
}

return copilot
