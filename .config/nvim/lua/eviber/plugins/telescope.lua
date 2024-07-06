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
		{ '<leader>pf',  callback('telescope.builtin', 'find_files'),  desc = 'Search files'             },
		{ '<leader>pw',  callback('telescope.builtin', 'grep_string'), desc = 'Search word'              },
		{ '<leader>pl',  callback('telescope.builtin', 'live_grep'),   desc = 'Live search'              },
		{ '<leader>pgf', callback('telescope.builtin', 'git_files'),   desc = 'Search git files'         },
		{ '<leader>pgw', callback('git_grep', 'grep'),                 desc = 'Search word in git files' },
		{ '<leader>pgl', callback('git_grep', 'live_grep'),            desc = 'Live search in git files' },
		{ '<leader>pn',  search_cfg,                                   desc = 'Search Neovim files'      },
	},
}
