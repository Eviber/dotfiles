-- Open diagnostic in floating window when jumping to it
local open_float = function(_, bufnr)
	vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
end
vim.diagnostic.config({ jump = { on_jump = open_float } })

-- Toggle virtual lines diagnostics between off, and all lines
local function toggle_virtual_lines_all()
	local current_config = vim.diagnostic.config().virtual_lines
	if current_config == true then
		vim.diagnostic.config({ virtual_lines = false })
	else
		vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
	end
end

-- Toggle virtual lines diagnostics between off, and current line only
local function toggle_virtual_line()
	local current_config = vim.diagnostic.config().virtual_lines
	if type(current_config) == 'table' and current_config.current_line == true then
		vim.diagnostic.config({ virtual_lines = false })
	else
		vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
	end
end

-- Toggle virtual text diagnostics
local function toggle_virtual_text()
	local current_config = vim.diagnostic.config().virtual_text
	if current_config == true then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
	end
end

vim.keymap.set("n", "<leader>vL", toggle_virtual_lines_all, { desc = "toggle Virtual Lines diagnostics" })
vim.keymap.set("n", "<leader>vl", toggle_virtual_line,      { desc = "toggle Virtual Line diagnostics" })
vim.keymap.set("n", "<leader>vt", toggle_virtual_text,      { desc = "toggle Virtual Text diagnostics" })
