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

vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

vim.g.mapleader = ' '
vim.g.rustfmt_autosave = 1

vim.opt.mouse = ''

vim.o.winborder = 'rounded'

vim.api.nvim_command('filetype plugin on')
vim.api.nvim_command('filetype indent on')

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] =  " ",
            [vim.diagnostic.severity.HINT] =  "󰌶 ",
        }
    }
})

-- Highlight on yank
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({higroup='Visual'})
  end,
  desc = "Briefly highlight yanked text",
  group = augroup("yank", { clear = true }),
})
