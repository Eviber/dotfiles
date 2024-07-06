local rulechecker_dir = "C:/Users/FT999180/Documents/FADEX/.nvim_rulechecker/"

function Copy_headers()
	vim.fn.execute('! .\\copy_h_file.bat')
end

-- Returns current file's CSC path or nil if not applicable
local function get_csc()
	local filepath = vim.fn.expand('%:p') -- Get the full path of the current file
	local parent = vim.fn.fnamemodify(filepath, ":p:h:t")
	if parent ~= '_Source' and parent ~= '_Intf' and parent ~= 'Sources' and parent ~= 'Headers' then
		return nil
	end
	local csc = vim.fn.fnamemodify(filepath, ":p:h:h")
	return csc
end

-- Find CSC from current file and generate a .ttp linked to all sources in it.
function Generate_ttp()
	local csc = get_csc()
	if csc == nil then
		print("can't find csc")
		return
	end
	local ttp_path = rulechecker_dir .. vim.fn.fnamemodify(csc, ':t') .. '.ttp'
	print(ttp_path)
	local ttp = io.open(ttp_path, "w")
	if ttp == nil then
		print('failure creating ttp file')
		return
	end
	local files = vim.split(vim.fn.glob(csc .. "/_Source/*.c") .. '\n' .. vim.fn.glob(csc .. "/Sources/*.c"), '\n')
	local template = io.open(rulechecker_dir .. 'template_ttp.txt')
	if template == nil then return end
	local ttp_content = template:read("*a")
	template:close()
	local idx = 20
	for _, file in pairs(files) do
		file = file:gsub("\\", "\\\\")
		ttp_content = ttp_content .. ',\n{"' .. idx .. '", "18", "' .. file .. '"}'
		idx = idx + 1
	end
	ttp_content = ttp_content .. '\n}\nEND\n'
	ttp:write(ttp_content)
	ttp:close()
end

vim.keymap.set('n', '<leader>rt', Generate_ttp, { desc = "Generate ttp" })
vim.keymap.set('n', '<leader>rr', Run_RuleChecker, { desc = "Run RuleChecker" })
vim.keymap.set('n', '<leader>rd', Generate_diagnostics, { desc = "Generate RuleChecker Diagnostics" })
vim.keymap.set('n', '<leader>rq', Generate_qflist, { desc = "Generate RuleChecker Quickfix List" })
