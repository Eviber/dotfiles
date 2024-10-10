-- open file explorer
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Open NetRW" })

-- move selected up and down with j and k
-- vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = "" })
-- vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv", { desc = "" })

-- keep cursor in place when pressing J
-- vim.keymap.set('n', 'J', "mzJ`z")

-- center cursor when moving half a page up/down
-- vim.keymap.set('n', '<C-d>', "<C-d>zz", { desc = "" })
-- vim.keymap.set('n', '<C-u>', "<C-u>zz", { desc = "" })

-- center cursor when moving to searched keyword and unfold as needed
-- vim.keymap.set('n', 'n', "nzzzv")
-- vim.keymap.set('n', 'N', "Nzzzv")

-- paste over selected without losing current buffer
vim.keymap.set('x', '<leader>p', '"_dP')

-- copy into clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = "Copy to clipboard" })
vim.keymap.set('v', '<leader>y', '"+y', { desc = "Copy to clipboard" })

-- delete without copying
vim.keymap.set('n', '<leader>d', '"_d', { desc = "Delete without yanking" })
vim.keymap.set('v', '<leader>d', '"_d', { desc = "Delete without yanking" })

-- center cursor when navigating with Quickfix
-- vim.keymap.set('n', '<C-j>', "<cmd>cprev<CR>zz")
-- vim.keymap.set('n', '<C-k>', "<cmd>cnext<CR>zz")
-- vim.keymap.set('n', '<leader>k', "<cmd>lprev<CR>zz")
-- vim.keymap.set('n', '<leader>j', "<cmd>lprev<CR>zz")

vim.keymap.set('n', '<leader>n', vim.cmd.bn, { desc = "Next buffer" })
vim.keymap.set('n', '<leader>N', vim.cmd.bN, { desc = "Previous buffer" })

-- start a search and replace on the current word
vim.keymap.set('n', '<leader>sr', ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gc<Left><Left><Left>", { desc = "Search and replace current word" })

-- toggle dark and light background
local function toggle_dark()
	if vim.o.background == 'dark' then
		vim.o.background = 'light'
	else
		vim.o.background = 'dark'
	end
end
vim.keymap.set('n', '<leader>b', toggle_dark, { desc = "Toggle dark/light theme" })

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "lua",
-- 	command = "setlocal noexpandtab",
-- })

vim.keymap.set('n', '<leader>lw', function() vim.cmd("set wrap!") end, { desc = "Toggle line wrap" })

if vim.g.neovide then
	vim.g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.05)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1/1.05)
	end)
end
