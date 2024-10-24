return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {},
	event = "VeryLazy",
	cmd = "Hardtime",
	config = {
		vim.keymap.set('n', '<leader>ht', function() vim.cmd("Hardtime toggle") end, { desc = "Toggle Hardtime" })
	}
}
