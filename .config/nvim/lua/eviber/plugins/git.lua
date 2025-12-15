return {
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		version = "*",
		keys = {
			{ "<leader>gs", vim.cmd.Neogit, desc = "Open Neogit status" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"sindrets/diffview.nvim",        -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua",              -- optional
			-- "echasnovski/mini.pick",         -- optional

			"ejrichards/baredot.nvim",
		},
		config = function()
			require("neogit").setup({ graph_style = "kitty" })
		end,
	},
	{
		'tpope/vim-fugitive',
		cmd = 'Git',
		dependencies = {
			{ "ejrichards/baredot.nvim" },
		},
	},
}
