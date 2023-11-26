config = function()
	local builtin = require('telescope.builtin')
	vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
	vim.keymap.set('n', '<C-p>', builtin.git_files, {})
	vim.keymap.set('n', '<leader>ps', function()
		builtin.grep_string(
			{ search = vim.fn.input("Grep > ") }
		)
	end)
end

return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		{'nvim-lua/plenary.nvim'}
	},
	config = config,
	keys = {
		'<leader>pf',
		'<C-p>',
		'<leader>ps'
	},
}
