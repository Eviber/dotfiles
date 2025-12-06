-- Hyprlang LSP
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
		pattern = {"*.hl", "hypr*.conf"},
		callback = function(event)
				-- print(string.format("starting hyprls for %s", vim.inspect(event)))
				vim.lsp.start {
						name = "hyprlang",
						cmd = {"hyprls"},
						root_dir = vim.fn.getcwd(),
						settings = {
							hyprls = {
								preferIgnoreFile = true, -- set to false to prefer `hyprls.ignore`
								ignore = {"hyprlock.conf", "hypridle.conf"}
							}
						}
					}
		end
})

return {
	{
		'neovim/nvim-lspconfig',
		version = '*',
		cmd = 'LspInfo',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{
				'saghen/blink.cmp',
				-- dependencies = { 'rafamadriz/friendly-snippets' },
				version = '1.*',

				---@module 'blink.cmp'
				---@type blink.cmp.Config
				opts = {},
			}
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(event)
					-- Open diagnostics in a floating window when jumping to them
					vim.diagnostic.config({ jump = { float = true } })

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

					local bufnr = event.buf
					vim.keymap.set("n", "grn",        vim.lsp.buf.rename,         { buffer = bufnr, desc = "Rename symbol" })
					vim.keymap.set("n", "grr",        vim.lsp.buf.references,     { buffer = bufnr, desc = "Symbol references" })
					vim.keymap.set("n", "gra",        vim.lsp.buf.code_action,    { buffer = bufnr, desc = "Open code actions" })
					vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     { buffer = bufnr, desc = "Go to definition" })
					vim.keymap.set("n", "<leader>K",  vim.cmd.Man,                { buffer = bufnr, desc = "Open Man page" })
					vim.keymap.set("i", "<C-h>",      vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature information" })
					vim.keymap.set("n", "<leader>vL", toggle_virtual_lines_all,   { buffer = bufnr, desc = "toggle Virtual Lines diagnostics" })
					vim.keymap.set("n", "<leader>vl", toggle_virtual_line,        { buffer = bufnr, desc = "toggle Virtual Line diagnostics" })
					vim.keymap.set("n", "<leader>vt", toggle_virtual_text,        { buffer = bufnr, desc = "toggle Virtual Text diagnostics" })

					-- local client = vim.lsp.get_client_by_id(event.data.client_id)
					-- if client == nil then return end
					-- if client:supports_method('textDocument/completion') then
					-- 	vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
					-- end

				end,
			})
		end
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^7', -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
