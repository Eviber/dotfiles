return {
	'tpope/vim-fugitive',
	cmd = 'Git',
	keys = {
		{ "<leader>gs", vim.cmd.Git, desc = "Open Fugitive git status" },
	},
	dependencies = {
		{ "ejrichards/baredot.nvim" },
	},
}
