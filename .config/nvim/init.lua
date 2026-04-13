require("pack_helper")

require("set")
require("remap")
require("diagnostic_settings")

-- Theme {{{

Pack {
	"folke/tokyonight.nvim",
	version = "*",
	after = function()
		vim.cmd("colorscheme tokyonight")
	end,
}

-- }}}

-- Oil (file explorer) {{{

Pack { "nvim-tree/nvim-web-devicons" }
-- Pack { "nvim-mini/mini.icons.git", opts = {} }
Pack {
	"stevearc/oil.nvim",
	version = "*",
	opts = { skip_confirm_for_simple_edits = true },
	keys = { { "n", "<leader>pv", vim.cmd.Oil, "Open Oil" } },
}

-- }}}

-- Copilot {{{

Pack { "github/copilot.vim" }
vim.g.copilot_filetypes = {
	["markdown"] = 1,
}
vim.g.copilot_enabled = false

-- }}}

-- lualine {{{

Pack { "1478zhcy/lualine-copilot" }
Pack { "nvim-lualine/lualine.nvim", opts = {
	sections = {
		lualine_x = {
			"copilot",
			"filetype",
			"fileformat",
			"encoding",
		}
	},
	options = { theme = "auto" }
} }

-- }}}

-- undo-tree {{{

vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Toggle undo tree" })

-- }}}

-- Completion {{{

-- -- Native autocompletion:
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(event)
-- 		local client = vim.lsp.get_client_by_id(event.data.client_id)
-- 		if client == nil then return end
-- 		if client:supports_method("textDocument/completion") then
-- 			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
-- 		end
-- 	end,
-- })

Pack { "rafamadriz/friendly-snippets" }
Pack { "saghen/blink.cmp", version = "1.*", opts = {} }

-- }}}

-- LSP {{{

Pack { "neovim/nvim-lspconfig" }

Pack {
	"folke/lazydev.nvim",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
	after = function()
		vim.lsp.enable("lua_ls")
	end,
}

Pack {
	"mrcjkb/rustaceanvim",
	version = "^8",
	after = function()
		vim.lsp.enable("rust-analyzer")
	end,
}

-- }}}

-- TODO Comments {{{

Pack { "nvim-lua/plenary.nvim" }
Pack { "folke/todo-comments.nvim", opts = {} }

-- }}}

-- Trouble {{{

-- Depends on "nvim-tree/nvim-web-devicons"
Pack {
	"folke/trouble.nvim",
	opts = {},
	keys = {
		{ "n", "<leader>xx", "Trouble diagnostics toggle",                        "Diagnostics (Trouble)" },
		{ "n", "<leader>xX", "Trouble diagnostics toggle filter.buf=0",           "Buffer Diagnostics (Trouble)" },
		{ "n", "<leader>cs", "Trouble symbols toggle focus=true",                 "Symbols (Trouble)" },
		{ "n", "<leader>cl", "Trouble lsp toggle focus=false win.position=right", "LSP Definitions / references / ... (Trouble)" },
		{ "n", "<leader>xL", "Trouble loclist toggle",                            "Location List (Trouble)" },
		{ "n", "<leader>xQ", "Trouble qflist toggle",                             "Quickfix List (Trouble)" },
	},
}

-- }}}

-- Which key {{{

Pack { "folke/which-key.nvim", version = "*", opts = {} }
vim.o.timeout = true
vim.o.timeoutlen = 1000

-- }}}

-- Telescope {{{

-- Dependencies:
-- "nvim-lua/plenary.nvim"

-- Optional: native engine
-- "nvim-telescope/telescope-fzf-native.nvim",
-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"

local function callback(module, fname)
	return function() require(module)[fname]() end
end

local function search_cfg()
	require("telescope.builtin").find_files { cwd = vim.fn.stdpath "config" }
end

Pack {
	"nvim-telescope/telescope.nvim",
	version = "0.2.x",
	opts = {},
	keys = {
		{ "n", "<leader>sf",  callback("telescope.builtin", "find_files"),  "Search files" },
		{ "n", "<leader>sw",  callback("telescope.builtin", "grep_string"), "Search word" },
		{ "n", "<leader>sl",  callback("telescope.builtin", "live_grep"),   "Live search" },
		{ "n", "<leader>sgf", callback("telescope.builtin", "git_files"),   "Search git files" },
		{ "n", "<leader>sgw", callback("git_grep", "grep"),                 "Search word in git files" },
		{ "n", "<leader>sgl", callback("git_grep", "live_grep"),            "Live search in git files" },
		{ "n", "<leader>sn",  search_cfg,                                   "Search Neovim files" },
	},
}

Pack {
	"davvid/telescope-git-grep.nvim",
	after = function()
		require("telescope").load_extension("git_grep")
	end,
}

vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopePreviewerLoaded",
	callback = function(args)
		if args.data.filetype == "markdown" then
			vim.wo.wrap = true
			vim.wo.lbr = true
		end
	end,
})

-- }}}

-- Showkeys {{{

Pack { "nvchad/showkeys" }

-- }}}

-- Git Plugins {{{

Pack { "sindrets/diffview.nvim" }

Pack { "https://plugins.ejri.dev/baredot.nvim", opts = { git_dir = "~/.dotfiles" } }

-- Dependencies:
-- "nvim-lua/plenary.nvim",         -- required
-- "sindrets/diffview.nvim",        -- optional - Diff integration

-- Only one of these is needed.
-- "nvim-telescope/telescope.nvim", -- optional
-- "ibhagwan/fzf-lua",              -- optional
-- "echasnovski/mini.pick",         -- optional

-- "ejrichards/baredot.nvim",

Pack {
	"NeogitOrg/neogit",
	version = "*",
	opts = { graph_style = "kitty" },
	keys = { { "n", "<leader>gs", vim.cmd.Neogit, "Open Neogit status" } },
}

Pack { "tpope/vim-fugitive" }

Pack { "lewis6991/gitsigns.nvim", version = "*", opts = {
	signcolumn = false,
	numhl = true,
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		local nh = function()
			if vim.wo.diff then
				vim.cmd.normal({"]c", bang = true})
			else
				gitsigns.nav_hunk("next")
			end
		end
		map("n", "]c", nh, { desc = "Next Git Hunk (gitsigns)" })

		local ph = function()
			if vim.wo.diff then
				vim.cmd.normal({"[c", bang = true})
			else
				gitsigns.nav_hunk("prev")
			end
		end
		map("n", "[c", ph, { desc = "Previous Git Hunk (gitsigns)" })

		-- Actions
		-- map("n", "<leader>hs", gitsigns.stage_hunk)
		-- map("n", "<leader>hr", gitsigns.reset_hunk)

		-- map("v", "<leader>hs", function()
		-- 	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		-- end)

		-- map("v", "<leader>hr", function()
		-- 	gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		-- end)

		-- map("n", "<leader>hS", gitsigns.stage_buffer)
		-- map("n", "<leader>hR", gitsigns.reset_buffer)
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Git Hunk (gitsigns)" })
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Git Hunk Inline (gitsigns)" })

		-- map("n", "<leader>hb", function()
		-- 	gitsigns.blame_line({ full = true })
		-- end)

		-- map("n", "<leader>hd", gitsigns.diffthis)

		-- map("n", "<leader>hD", function()
		-- 	gitsigns.diffthis("~")
		-- end)

		-- Populate the quickfix list with hunks. Automatically opens the quickfix window.
		-- map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { desc = "Set Quickfix List with All Hunks (gitsigns)" })
		-- map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set Quickfix List with Current Buffer's Hunks (gitsigns)" })

		-- Toggles
		-- map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame (gitsigns)" })
		map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff (gitsigns)" })

		-- Text object
		-- map({"o", "x"}, "ih", gitsigns.select_hunk, { desc = "Select Git Hunk (gitsigns)" })
	end
} }

-- }}}

-- HardTime (disabled) {{{

-- Pack { "MunifTanjim/nui.nvim" }

-- dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },

-- Pack { "m4xshen/hardtime.nvim", opts = {}, keys = { { "n", "<leader>ht", "Hardtime toggle", "Toggle Hardtime" } } }

-- }}}

-- Cord {{{

Pack { "vyfor/cord.nvim", build = "Cord update" }

-- }}}

-- Crates {{{

Pack { "saecki/crates.nvim", version = "stable", opts = {
	lsp = {
		enabled = true,
		-- on_attach = function(client, bufnr)
		-- 	-- the same on_attach function as for your other language servers
		-- 	-- can be ommited if you're using the `LspAttach` autocmd
		-- end,
		actions = true,
		completion = true,
		hover = true,
	},
}}

-- }}}

-- Guess indent {{{

Pack { "NMAC427/guess-indent.nvim", opts = {} }

-- }}}

-- hawtkeys (disabled) {{{

-- Dependencies
-- "nvim-lua/plenary.nvim",
-- "nvim-treesitter/nvim-treesitter",

Pack { "tris203/hawtkeys.nvim" }

-- }}}

-- Treesitter {{{

Pack {
	"nvim-treesitter/nvim-treesitter",
	after = function()
		require("nvim-treesitter").install { "rust", "c", "lua", "javascript" }
	end,
	build = vim.cmd.TSUpdate,
}

Pack { "nvim-treesitter/nvim-treesitter-context" }

-- }}}

PackLoad()

-- vim:foldmethod=marker
