return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true },
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
				options = { theme = 'onedark' }
			}
		end
	},
	"1478zhcy/lualine-copilot",
}
