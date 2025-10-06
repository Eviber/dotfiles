return {
	'lewis6991/gitsigns.nvim',
	version = "*",
	event = 'BufEnter *.*',
	opts = {
		signcolumn = false,
		numhl = true,
		on_attach = function(bufnr)
			local gitsigns = require('gitsigns')

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			local nh = function()
				if vim.wo.diff then
					vim.cmd.normal({']c', bang = true})
				else
					gitsigns.nav_hunk('next')
				end
			end
			map('n', ']c', nh, { desc = "Next Git Hunk (gitsigns)" })

			local ph = function()
				if vim.wo.diff then
					vim.cmd.normal({'[c', bang = true})
				else
					gitsigns.nav_hunk('prev')
				end
			end
			map('n', '[c', ph, { desc = "Previous Git Hunk (gitsigns)" })

			-- Actions
			-- map('n', '<leader>hs', gitsigns.stage_hunk)
			-- map('n', '<leader>hr', gitsigns.reset_hunk)

			-- map('v', '<leader>hs', function()
			-- 	gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
			-- end)

			-- map('v', '<leader>hr', function()
			-- 	gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
			-- end)

			-- map('n', '<leader>hS', gitsigns.stage_buffer)
			-- map('n', '<leader>hR', gitsigns.reset_buffer)
			map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Preview Git Hunk (gitsigns)" })
			map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = "Preview Git Hunk Inline (gitsigns)" })

			-- map('n', '<leader>hb', function()
			-- 	gitsigns.blame_line({ full = true })
			-- end)

			-- map('n', '<leader>hd', gitsigns.diffthis)

			-- map('n', '<leader>hD', function()
			-- 	gitsigns.diffthis('~')
			-- end)

			-- Populate the quickfix list with hunks. Automatically opens the quickfix window.
			-- map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { desc = "Set Quickfix List with All Hunks (gitsigns)" })
			-- map('n', '<leader>hq', gitsigns.setqflist, { desc = "Set Quickfix List with Current Buffer's Hunks (gitsigns)" })

			-- Toggles
			-- map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame (gitsigns)" })
			map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "Toggle Word Diff (gitsigns)" })

			-- Text object
			-- map({'o', 'x'}, 'ih', gitsigns.select_hunk, { desc = "Select Git Hunk (gitsigns)" })
		end
	},
	dependencies = {
		{ "ejrichards/baredot.nvim" },
	},
}
