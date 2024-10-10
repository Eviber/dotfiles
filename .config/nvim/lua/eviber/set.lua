vim.opt.compatible = false

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.list = true
vim.opt.listchars = { tab = '| ', trail = '·', precedes = '«', extends = '»' }

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.scroll = 1

vim.opt.updatetime = 50

vim.opt.colorcolumn = "121"

vim.g.mapleader = ' '

vim.opt.mouse = ''

vim.api.nvim_command('filetype plugin on')
vim.api.nvim_command('filetype indent on')

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
