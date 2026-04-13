local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- open file explorer
map('n', '<leader>pv', vim.cmd.Ex, "Open NetRW")

-- move selected up and down with j and k
-- map('v', 'J', ":m '>+1<CR>gv=gv", { desc = "" })
-- map('v', 'K', ":m '>-2<CR>gv=gv", { desc = "" })

-- keep cursor in place when pressing J
-- map('n', 'J', "mzJ`z")

-- center cursor when moving half a page up/down
-- map('n', '<C-d>', "<C-d>zz", { desc = "" })
-- map('n', '<C-u>', "<C-u>zz", { desc = "" })

-- center cursor when moving to searched keyword and unfold as needed
-- map('n', 'n', "nzzzv")
-- map('n', 'N', "Nzzzv")

-- paste over selected without losing current buffer
map('x', '<leader>p', '"_dP')

-- copy into clipboard
map('n', '<leader>y', '"+y', "Copy to clipboard")
map('v', '<leader>y', '"+y', "Copy to clipboard")

-- delete without copying
map('n', '<leader>d', '"_d', "Delete without yanking")
map('v', '<leader>d', '"_d', "Delete without yanking")

-- center cursor when navigating with Quickfix
-- map('n', '<C-j>', "<cmd>cprev<CR>zz")
-- map('n', '<C-k>', "<cmd>cnext<CR>zz")
-- map('n', '<leader>k', "<cmd>lprev<CR>zz")
-- map('n', '<leader>j', "<cmd>lprev<CR>zz")

map('n', '<leader>n', vim.cmd.bn, "Next buffer")
map('n', '<leader>N', vim.cmd.bN, "Previous buffer")

-- start a search and replace on the current word
map('n', '<leader>sr', ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gc<Left><Left><Left>", "Search and replace current word")

-- toggle dark and light background
local function toggle_dark()
	if vim.o.background == 'dark' then
		vim.o.background = 'light'
	else
		vim.o.background = 'dark'
	end
end
map('n', '<leader>b', toggle_dark, "Toggle dark/light theme")

map('n', '<leader>lw', function() vim.cmd("set wrap!") end, "Toggle line wrap")

if vim.g.neovide then
	vim.g.neovide_scale_factor = 1.0
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
	end
	map("n", "<C-=>", function()
		change_scale_factor(1.05)
	end)
	map("n", "<C-->", function()
		change_scale_factor(1/1.05)
	end)
end
