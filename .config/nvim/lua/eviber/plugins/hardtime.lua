return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	opts = {},
	event = "VeryLazy",
	cmd = "Hardtime",
	keys = {
		{ '<leader>ht', function() vim.cmd("Hardtime toggle") end, desc = "Toggle Hardtime" },
	},
}
