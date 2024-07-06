---@diagnostic disable: undefined-field

local uv = vim.loop

local rulechecker_violations = {}
local rulechecker_relaxes = {}

-- https://github.com/rktjmp/fwatch.nvim/blob/main/lua/fwatch.lua
-- @doc """
-- Watch path and calls on_event(filename, events)
-- """
local function watch_with_function(path, on_event)
	local handle = uv.new_fs_event()

	-- these are just the default values
	local flags = {
		watch_entry = false, -- true = when dir, watch dir inode, not dir content
		stat = false, -- true = don't use inotify/kqueue but periodic check, not implemented
		recursive = false -- true = watch dirs inside dirs
	}

	local unwatch_cb = function()
		uv.fs_event_stop(handle)
	end

	local event_cb = function(err, filename, events)
		if err then
			print("error watching " .. path)
		else
			on_event(filename, events, unwatch_cb)
		end
	end

	-- attach handler
	uv.fs_event_start(handle, path, flags, event_cb)

	return handle
end

local function find_chk()
	local filepath = vim.fn.expand('%:p') -- Get the full path of the current file
	local csc = vim.fn.fnamemodify(filepath, ":p:h:h:t")
	local file = 'C:/Users/FT999180/Documents/FADEX/.nvim_rulechecker/Logiscope/' .. csc .. '.chk'
	return file
end

local function find_drg()
	local filepath = vim.fn.expand('%:p') -- Get the full path of the current file
	local csc = vim.fn.fnamemodify(filepath, ":p:h:h:t")
	local file = 'C:/Users/FT999180/Documents/FADEX/.nvim_rulechecker/Logiscope/' .. csc .. '.drg'
	return file
end

local function find_ttp()
	local filepath = vim.fn.expand('%:p') -- Get the full path of the current file
	local csc = vim.fn.fnamemodify(filepath, ":p:h:h:t")
	local file = 'C:/Users/FT999180/Documents/FADEX/.nvim_rulechecker/' .. csc .. '.ttp'
	return file
end

local function read_file(path)
	local file = io.open(path, "r") -- r read mode
	if not file then return nil end
	local content = file:read("*a") -- *a or *all reads the whole file
	file:close()
	return content
end

-- Function to split a string by lines
local function splitLines(inputstr)
	local t = {}
	local function helper(line) table.insert(t, line) return "" end
	helper((inputstr:gsub("(.-)\r?\n", helper)))
	return t
end

local function removeBeforeLastSlash(inputStr)
	local index = 0

	-- Find the last occurrence of slash or backslash
	index = inputStr:match(".*[\\/]()")

	-- Return the substring after the last slash or backslash
	return string.sub(inputStr, index)
end

local function removeBeforeLastUnderscore(inputStr)
	if inputStr == nil or inputStr == "" then
		return nil
	end
	local index = 0

	-- Find the last occurrence of slash or backslash
	index = inputStr:match(".*[_]()")

	if not index then
		-- print('removeBeforeLastUnderscore: no match in \'' .. inputStr .. '\'')
		return nil
	end

	-- Return the substring after the last slash or backslash
	return string.sub(inputStr, index)
end

local function parseViolation(line)
	local resultTable = {}
	local index = 1

	-- Split the input string based on tabulation
	for substring in line:gmatch("[^\t]+") do
		substring = substring:gsub("^\"(.-)\"$", "%1")
		if index == 1 then -- filename
			substring = removeBeforeLastSlash(substring)
		elseif index == 4 then -- violation code
			substring = removeBeforeLastUnderscore(substring)
		end
		if index == 1 or index == 3 or index == 4 or index == 5 then
			if substring == nil then return nil end
			table.insert(resultTable, substring)
		end
		index = index + 1
	end

	if resultTable[2] == nil then
		print('error on ', line)
		return nil
	end
	return resultTable
end

-- Parse a drg line into a hash
local function parseRelax(line)
	local hash = ""
	local index = 1

	-- Split the input string based on tabulation
	for substring in line:gmatch("[^\t]+") do
		substring = substring:gsub("^\"(.-)\"$", "%1")
		if (substring == nil) then
			return
		end
		if index == 1 then
			substring = removeBeforeLastSlash(substring)
		elseif index == 4 then
			substring = removeBeforeLastUnderscore(substring)
		end
		if index == 1 or index == 3 or index == 4 then
			if substring == nil then
				return
			end
			hash = hash .. substring
		end
		index = index + 1
	end

	return hash
end

local function parseViolations(lines)
	local filteredLines = {}
	for _, line in ipairs(lines) do
		if (string.match(line, "^\".:") or string.match(line, "^\"headers")) and not string.find(line, "-1") and not rulechecker_relaxes[parseRelax(line)] then
			local x = parseViolation(line)
			table.insert(filteredLines, x)
		end
	end
	return filteredLines
end

local function parseRelaxes(lines)
	local relaxes = {}
	for _, line in ipairs(lines) do
		if string.match(line, "^\".:") and not string.find(line, "-1") then
			local relax = parseRelax(line)
			if relax ~= nil then
				relaxes[relax] = true
			end
		end
	end
	return relaxes
end

local function updateViolations(chk, drg)
	if not chk then chk = find_chk() end
	if not drg then drg = find_drg() end
	local chk_content = read_file(chk);
	if not chk_content then return end
	local drg_content = read_file(drg);
	if not drg_content then return end
	-- Split the string into lines
	local chk_lines = splitLines(chk_content)
	local drg_lines = splitLines(drg_content)
	-- Filter the lines
	rulechecker_relaxes = parseRelaxes(drg_lines)
	rulechecker_violations = parseViolations(chk_lines)
end

function PrintViolations()
	updateViolations()
	-- Print the filtered lines
	for _, violation in ipairs(rulechecker_violations) do
		-- Print the result table
		local str = ""
		for i, substring in ipairs(violation) do
			if i > 1 then
				str = str .. ' - '
			end
			str = str .. substring
		end
		print(str)
	end
end

local root = ""
local files = {}
local matches = {}

function Showfiles()
	for _, file in ipairs(files) do
		print(file)
	end
end

local function build_qf(violation, cur_root)
	if root ~= cur_root then
		root = cur_root
		if not vim.fn.isdirectory(root) then return {} end
		local cmd = "Git ls-files --full-name " .. root
		files = vim.fn.split(vim.fn.execute(cmd), '\n')
	end
	if not matches[violation[1]] then
		local match = nil
		for _, line in ipairs(files) do
			if string.find(line, '/' .. violation[1]) then
				if match ~= nil then
					print("multiple matches for " .. violation[1] .. ", ignoring")
					return {}
				end
				match = line
			end
		end
		if match == nil then
			print("no match for " .. violation[1])
			return {}
		end
		matches[violation[1]] = match
	end
	local line = tonumber(violation[2])
	return {
		filename = root .. '/' .. matches[violation[1]],
		lnum = line,
		col = vim.fn.getline(line + 1):match("^%s*"):len(),
		end_col = vim.fn.getline(line + 1):len(),
		nr = violation[3],
		text = violation[4],
		type = "W",
	}
end

function Generate_diagnostics()
	updateViolations()
	if #rulechecker_violations == 0 then return end
	local namespace = vim.api.nvim_create_namespace("RuleChecker")
	local rulechecker_diagnostics = {}
	local bufnr = vim.fn.bufnr()
	for _, violation in ipairs(rulechecker_violations) do
		local line = tonumber(violation[2]) - 1 -- lines are 0 indexed
		if violation[1] == removeBeforeLastSlash(vim.api.nvim_buf_get_name(0)) then
			local diag = {
				bufnr = bufnr,
				lnum = line,
				col = vim.fn.getline(line + 1):match("^%s*"):len(),
				end_col = vim.fn.getline(line + 1):len(),
				severity = vim.diagnostic.severity.WARN,
				message = violation[4],
				source = "RuleChecker",
				code = violation[3],
				namespace = namespace,
			}
			table.insert(rulechecker_diagnostics, diag)
		end
	end
	vim.diagnostic.set(namespace, bufnr, rulechecker_diagnostics, nil)
end

function Generate_qflist()
	updateViolations()
	if #rulechecker_violations == 0 then return end
	local rulechecker_quickfixlist = {}
	local cur_root = vim.fn.split(vim.fn.execute("! git rev-parse --show-toplevel", "silent!"), '\n')[3]
	for _, violation in ipairs(rulechecker_violations) do
		local qf = build_qf(violation, cur_root)
		table.insert(rulechecker_quickfixlist, qf)
	end
	if #rulechecker_quickfixlist ~= 0 then
		vim.fn.setqflist(rulechecker_quickfixlist)
	end
end

local current_chk = ""
local watch_handle

local function onEnter()
	local chk = find_chk()
	if chk ~= current_chk then
		if watch_handle then
			uv.fs_event_stop(watch_handle)
		end
		watch_handle = watch_with_function(find_drg(), function()
			vim.schedule(function()
				Generate_diagnostics()
			end)
		end)
		watch_handle = watch_with_function(chk, function()
			vim.schedule(function()
				Generate_diagnostics()
			end)
		end)
		current_chk = chk
	end
	Generate_diagnostics()
end

vim.api.nvim_create_autocmd('BufEnter', {
	pattern = {'*.c', '*.h', '*.s'},
	callback = onEnter,
})

local function start_rulechecker_job(ttp)
	local rulechecker = '"C:/Program Files (x86)/Kalimetrix/Logiscope/7.2.2/bin/batch.exe"'
	local exit_cb = function()
		print("RuleChecker job finished")
		vim.g.rulechecker = nil
		onEnter()
	end
	vim.g.rulechecker = "RuleChecker running..."
	vim.fn.jobstart(rulechecker .. ' \"' .. ttp .. '\" -addin SYNCHRONe -cs -report', {on_exit = exit_cb})
end

-- Run RuleChecker
function Run_RuleChecker()
	if vim.g.rulechecker then
		print('RuleChecker already running')
		return
	end
	local ttp = vim.fn.expand('%:p') -- Get the full path of the current file
	if vim.fn.expand('%:t:e') ~= 'ttp' then
		ttp = find_ttp()
	end
	if vim.fn.filereadable(ttp) ~= 0 then
		start_rulechecker_job(ttp)
	else
		print(ttp .. " does not exist")
	end
end
