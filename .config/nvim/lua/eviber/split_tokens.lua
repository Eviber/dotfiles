function Split_tokens()
	-- Get the current buffer
	local buf = vim.api.nvim_get_current_buf()

	-- Get the current cursor position
	local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))

	-- Get the current line
	local line = vim.api.nvim_buf_get_lines(buf, cursor_row - 1, cursor_row, false)[1]

	-- Get the parser for the current filetype
	local parser = vim.treesitter.get_parser()

	-- Parse the current line
	local tree = parser:parse()[1]:root():named_descendant_for_range(cursor_row, 0, cursor_row, #line)

	-- Define a function to insert newlines between tokens on the current line
	local function insert_newlines(node, line_str)
		-- Get the start and end positions of the node
		local _, end_byte = node:range()

		-- Check if the node is not a whitespace token
		if node:type() ~= "whitespace" then
			-- Insert a newline after the token in the line string
			line_str = line_str:sub(1, end_byte - 1) .. "\n" .. line_str:sub(end_byte)
		end

		-- Recursively traverse the node's children
		for child in node:iter_children() do
			line_str = insert_newlines(child, line_str)
		end

		return line_str
	end

	-- Call the function with the root node of the parsed tree and the current line
	local new_line = insert_newlines(tree, line)

	print(new_line)
	-- Replace the current line with the modified line
	vim.api.nvim_buf_set_lines(buf, cursor_row, cursor_row + 1, false, { new_line })
end
