return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{'L3MON4D3/LuaSnip'},
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require('cmp')
			local cmp_action = lsp_zero.cmp_action()

			cmp.setup({
				formatting = lsp_zero.cmp_format({details = true}),
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<C-f>'] = cmp_action.luasnip_jump_forward(),
					['<C-b>'] = cmp_action.luasnip_jump_backward(),
				})
			})
		end
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = 'LspInfo',
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{'folke/neodev.nvim'},
			{'hrsh7th/cmp-nvim-lsp'},
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(_, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({buffer = bufnr})
			end)

			vim.keymap.set("n", "gd",           vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "K",            vim.lsp.buf.hover, { desc = "Hover definition" })
			vim.keymap.set("n", "<leader>vws",  vim.lsp.buf.workspace_symbol, { desc = "Search symbol in workspace" })
			vim.keymap.set("n", "<leader>vd",   vim.diagnostic.open_float, { desc = "Show diagnostic" })
			vim.keymap.set("n", "]d",           vim.diagnostic.goto_next, { desc = "Go to next error" })
			vim.keymap.set("n", "[d",           vim.diagnostic.goto_prev, { desc = "Go to previous error" })
			vim.keymap.set("n", "<leader>vca",  vim.lsp.buf.code_action, { desc = "Open code actions" })
			vim.keymap.set("n", "<leader>vrr",  vim.lsp.buf.references, { desc = "Symbol references" })
			vim.keymap.set("n", "<leader>vrn",  vim.lsp.buf.rename, { desc = "Rename symbol" })
			vim.keymap.set("i", "<C-h>",        vim.lsp.buf.signature_help)

			-- (Optional) Configure lua language server for neovim
			-- local lua_opts = lsp_zero.nvim_lua_ls()
			-- require('lspconfig').lua_ls.setup(lua_opts)

			require('lspconfig').clangd.setup({
				-- cmd = { "C:\\Users\\FT999180\\.bin\\clangd.exe" },
				filetypes = { "c", "cpp" },
				root_dir = require('lspconfig').util.root_pattern(
					'.clangd',
					'.clang-tidy',
					'.clang-format',
					'compile_commands.json',
					'compile_flags.txt',
					'configure.ac',
					'.git'
				),
			})

			require('lspconfig').lua_ls.setup({
				cmd = { "C:\\Users\\FT999180\\.bin\\lua-language-server-3.7.4-win32-x64\\bin\\lua-language-server.exe" },
				before_init = require("neodev.lsp").before_init,
			})
		end
	}
}

-- local cmp_mappings = lsp.defaults.cmp_mappings({
-- 	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
-- 	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
-- 	['<Return>'] = cmp_confirm,
-- 	["<Tab>"] = cmp_confirm,
-- 	['<C-Space>'] = cmp.mapping.complete(),
-- })
