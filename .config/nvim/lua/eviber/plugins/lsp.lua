return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = true,
		config = false,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{'L3MON4D3/LuaSnip'},
		},
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
        end,
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				sources = {
					{name = 'nvim_lsp'},
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
				}),
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
			})
		end
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		version = '*',
		cmd = 'LspInfo',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{'folke/neodev.nvim'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'williamboman/mason.nvim'},
			{
				'williamboman/mason-lspconfig.nvim',
				version = '*',
			},
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require('lsp-zero')

			local lsp_attach = function(_, bufnr)
				vim.keymap.set("n", "gd",           vim.lsp.buf.definition,       { buffer = bufnr, desc = "Go to definition" })
				vim.keymap.set("n", "K",            vim.lsp.buf.hover,            { buffer = bufnr, desc = "Hover definition" })
				vim.keymap.set("n", "<leader>vws",  vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "Search symbol in workspace" })
				vim.keymap.set("n", "<leader>vd",   vim.diagnostic.open_float,    { buffer = bufnr, desc = "Show diagnostic" })
				vim.keymap.set("n", "]d",           vim.diagnostic.goto_next,     { buffer = bufnr, desc = "Go to next error" })
				vim.keymap.set("n", "[d",           vim.diagnostic.goto_prev,     { buffer = bufnr, desc = "Go to previous error" })
				vim.keymap.set("n", "<leader>vca",  vim.lsp.buf.code_action,      { buffer = bufnr, desc = "Open code actions" })
				vim.keymap.set("n", "<leader>vrr",  vim.lsp.buf.references,       { buffer = bufnr, desc = "Symbol references" })
				vim.keymap.set("n", "<leader>vrn",  vim.lsp.buf.rename,           { buffer = bufnr, desc = "Rename symbol" })
				vim.keymap.set("i", "<C-h>",        vim.lsp.buf.signature_help,   { buffer = bufnr, desc = "Signature information" })
            end

			lsp_zero.extend_lspconfig({
				sign_text = true,
				lsp_attach = lsp_attach,
				capabilities = require('cmp_nvim_lsp').default_capabilities()
			})

			require('mason').setup()
			require('mason-lspconfig').setup({
				ensure_installed = { 'clangd', 'lua_ls', 'rust_analyzer' },
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,


					rust_analyzer = lsp_zero.noop,
				}
			})

			vim.g.rustaceanvim = {
				server = {
					capabilities = lsp_zero.get_capabilities()
				},
			}
		end
	},

	{
		'mrcjkb/rustaceanvim',
		version = '^5', -- Recommended
		lazy = false, -- This plugin is already lazy
	},
}
