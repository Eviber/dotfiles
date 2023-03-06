local lsp = require('lsp-zero')

lsp.preset("recommended")

lsp.ensure_installed = {
	"rust_analyzer",
	"clangd",
	"sumneko-lua",
}

local rust_lsp = lsp.build_options('rust_analyzer', {})
local clangd_lsp = lsp.build_options('clangd', {})

lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_confirm = cmp.mapping.confirm({
	select = true,
	behavior = cmp.ConfirmBehavior.Replace
})
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<Return>'] = cmp_confirm,
	["<Tab>"] = cmp_confirm,
	['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
	sources = {
		{name = 'path', group_index = 2},
		{name = 'nvim_lsp', group_index = 2},
		{name = 'buffer', keyword_length = 3, group_index = 2},
		{name = 'luasnip', keyword_length = 2, group_index = 2},
		-- {name = 'copilot', group_index = 2},
	},
})

local on_attach = function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set("n", "gd",           function() vim.lsp.buf.definition() end,        opts)
	vim.keymap.set("n", "K",            function() vim.lsp.buf.hover() end,             opts)
	vim.keymap.set("n", "<leader>vws",  function() vim.lsp.buf.workspace_symbol() end,  opts)
	vim.keymap.set("n", "<leader>vd",   function() vim.diagnostic.open_float() end,     opts)
	vim.keymap.set("n", "]d",           function() vim.diagnostic.goto_next() end,      opts)
	vim.keymap.set("n", "[d",           function() vim.diagnostic.goto_prev() end,      opts)
	vim.keymap.set("n", "<leader>vca",  function() vim.lsp.buf.code_action() end,       opts)
	vim.keymap.set("n", "<leader>vrr",  function() vim.lsp.buf.references() end,        opts)
	vim.keymap.set("n", "<leader>vrn",  function() vim.lsp.buf.rename() end,            opts)
	vim.keymap.set("i", "<C-h>",        function() vim.lsp.buf.signature_help() end,    opts)
end

-- (Optional) Configure lua language server for neovim
lsp.on_attach(on_attach)
lsp.setup()

require("rust-tools").setup ({
		server = rust_lsp,
	})
require("clangd_extensions").setup ({
		server = clangd_lsp,
	})

-- Rust stuff
vim.g.rustfmt_autosave = 1
vim.g.rust_format_show_errors = 1
vim.g.rust_format_show_errors_delay = 0
vim.g.rust_fold = 1
