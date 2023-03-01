-- open file explorer
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- move selected up and down with J and K
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv")

-- keep cursor in place when pressing J
-- vim.keymap.set('n', 'J', "mzJ`z")

-- center cursor when moving half a page up/down
vim.keymap.set('n', '<C-d>', "<C-d>zz")
vim.keymap.set('n', '<C-u>', "<C-u>zz")

-- center cursor when moving to searched keyword and unfold as needed
vim.keymap.set('n', 'n', "nzzzv")
vim.keymap.set('n', 'N', "Nzzzv")

-- paste over selected without losing current buffer
vim.keymap.set('x', '<leader>p', '"_dP')

-- copy into clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>y', '"+Y')

-- delete without copying
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')

-- center cursor when navigating with Quickfix
-- vim.keymap.set('n', '<C-j>', "<cmd>cprev<CR>zz")
-- vim.keymap.set('n', '<C-k>', "<cmd>cnext<CR>zz")
-- vim.keymap.set('n', '<leader>k', "<cmd>lprev<CR>zz")
-- vim.keymap.set('n', '<leader>j', "<cmd>lprev<CR>zz")

-- start a search and replace on the current word
vim.keymap.set('n', '<leader>s', ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gc<Left><Left><Left>")

-- toggle Copilot
vim.keymap.set('n', '<leader>c', ":lua vim.api.nvim_set_var('copilot_enabled', not vim.api.nvim_get_var('copilot_enabled'))<CR>")
