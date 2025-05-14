return {
	'stevearc/oil.nvim',
	version = '*',
	lazy = false,
	opts = {
		skip_confirm_for_simple_edits = true,
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ '<leader>pv', vim.cmd.Oil, desc = "Launch Oil" },
	}
}
