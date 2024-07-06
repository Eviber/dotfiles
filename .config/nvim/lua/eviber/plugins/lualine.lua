return {
	{
		'nvim-lualine/lualine.nvim',
		event = 'BufEnter *.*',
		dependencies = { 'nvim-tree/nvim-web-devicons', '1478zhcy/lualine-copilot' },
		config = function()
			require('lualine').setup {
				sections = {
					lualine_x = {
						'g:rulechecker',
						-- {
						-- 	require('lazy.status').updates,
						-- 	cond = require('lazy.status').has_updates,
						-- },
						-- "copilot",
						"filetype",
						"fileformat",
						"encoding",
					}
				},
				options = { theme = 'tokyonight' }
			}
		end
	},
}
