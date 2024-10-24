local config = function()

	require('telescope').setup {
		extensions = {
			-- fzf = {},
		}
	}

	-- require('telescope').load_extension('fzf')
	require('telescope').load_extension('git_grep')
end

local function search_cfg()
	require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end

local function callback(module, fname)
	return function() require(module)[fname]() end
end

return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		{'nvim-lua/plenary.nvim'},
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
		},
		{'https://gitlab.com/davvid/telescope-git-grep.nvim'},
	},
	config = config,
	cmd = { 'Telescope' },
	keys = {
		{ '<leader>sf',  callback('telescope.builtin', 'find_files'),  desc = 'Search files'             },
		{ '<leader>sw',  callback('telescope.builtin', 'grep_string'), desc = 'Search word'              },
		{ '<leader>sl',  callback('telescope.builtin', 'live_grep'),   desc = 'Live search'              },
		{ '<leader>sgf', callback('telescope.builtin', 'git_files'),   desc = 'Search git files'         },
		{ '<leader>sgw', callback('git_grep', 'grep'),                 desc = 'Search word in git files' },
		{ '<leader>sgl', callback('git_grep', 'live_grep'),            desc = 'Live search in git files' },
		{ '<leader>sn',  search_cfg,                                   desc = 'Search Neovim files'      },
	},
}
