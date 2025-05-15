return {
	-- Autocompletion
	-- {
	-- 	'hrsh7th/nvim-cmp',
	-- 	event = 'InsertEnter',
	-- 	dependencies = {
	-- 		{'L3MON4D3/LuaSnip'},
	-- 	},
	-- 	opts = function(_, opts)
	-- 		opts.sources = opts.sources or {}
	-- 		table.insert(opts.sources, {
	-- 			name = "lazydev",
	-- 			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
	-- 		})
        -- end,
	-- 	config = function()
	-- 		local cmp = require('cmp')

	-- 		cmp.setup({
	-- 			sources = {
	-- 				{name = 'nvim_lsp'},
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				['<C-Space>'] = cmp.mapping.complete(),
	-- 				['<C-u>'] = cmp.mapping.scroll_docs(-4),
	-- 				['<C-d>'] = cmp.mapping.scroll_docs(4),
	-- 			}),
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					vim.snippet.expand(args.body)
	-- 				end,
	-- 			},
	-- 		})
	-- 	end
	-- },

	-- LSP
	{
		'neovim/nvim-lspconfig',
		version = '*',
		cmd = 'LspInfo',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			-- {'hrsh7th/cmp-nvim-lsp'},
			{'mason-org/mason.nvim'},
			{'mason-org/mason-lspconfig.nvim'},
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(event)
					local bufnr = event.buf
					local function toggle_virtual_lines()
						if vim.diagnostic.config().virtual_lines ~= true then
							vim.diagnostic.config({ virtual_lines = true })
						else
							vim.diagnostic.config({ virtual_lines = { current_line = true }})
						end
					end

					vim.keymap.set("n", "grn",        vim.lsp.buf.rename,         { buffer = bufnr, desc = "Rename symbol" })
					vim.keymap.set("n", "grr",        vim.lsp.buf.references,     { buffer = bufnr, desc = "Symbol references" })
					vim.keymap.set("n", "gra",        vim.lsp.buf.code_action,    { buffer = bufnr, desc = "Open code actions" })
					vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     { buffer = bufnr, desc = "Go to definition" })
					vim.keymap.set("n", "<leader>K",  vim.cmd.Man,                { buffer = bufnr, desc = "Open Man page" })
					vim.keymap.set("i", "<C-h>",      vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature information" })
					vim.keymap.set("n", "<leader>vl", toggle_virtual_lines,       { buffer = bufnr, desc = "toggle Virtual Lines diagnostics" })

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client == nil then return end
					if client:supports_method('textDocument/completion') then
						vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
					end

				end,
			})

			require('mason').setup()
			require('mason-lspconfig').setup({
				ensure_installed = {},
				automatic_enable = {
					exclude = {
						"rust_analyzer",
					}
				},
			})
		end
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^6', -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
