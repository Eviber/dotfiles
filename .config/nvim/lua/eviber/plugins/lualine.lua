return {
	{
		'nvim-lualine/lualine.nvim',
		event = 'VeryLazy',
		dependencies = { 'kyazdani42/nvim-web-devicons', '1478zhcy/lualine-copilot' },
		config = function()
			require('lualine').setup {
				sections = {
					lualine_x = {
						{
							require('lazy.status').updates,
							cond = require('lazy.status').has_updates,
						},
						"copilot",
						"filetype",
						"fileformat",
						"encoding",
					}
				},
				options = { theme = 'ayu' }
			}
		end
	},
}
