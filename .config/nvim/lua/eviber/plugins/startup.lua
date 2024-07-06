return {
	{
		'nvimdev/dashboard-nvim',
		enabled = false,
		event = 'VimEnter',
		config = function()
			require('dashboard').setup {
				-- config
			}
		end,
		dependencies = { {'nvim-tree/nvim-web-devicons'}}
	},
	{
		'CWood-sdf/spaceport.nvim',
		opts = {
			projectEntry = 'Oil',
		},
		-- lazy = false, -- load spaceport immediately
	}
}
