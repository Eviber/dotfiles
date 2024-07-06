return {
	'stevearc/oil.nvim',
	lazy = false,
	opts = {
		skip_confirm_for_simple_edits = true,
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = {
		vim.keymap.set('n', '<leader>pv', vim.cmd.Oil, { desc = "Launch Oil" })
	}
}
