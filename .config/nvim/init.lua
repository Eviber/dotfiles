require("set")
require("lsp")
require("remap")
require("diagnostic_settings")

-- Helper functions {{{

---Helper to convert a string|function into a function via vim.cmd if needed
---@param callback function|string
---@return function
local function ensure_callback(callback)
	if type(callback) == "function" then
		return callback
	elseif type(callback) == "string" then
		return function() vim.cmd(callback) end
	end
	error("Invalid callback type: " .. type(callback))
end

---@class AddPackKeymap
---@field [1] string Mode
---@field [2] string Keymap
---@field [3] function|string Command
---@field [4]? string Description

---Helper to set multiple keymaps
---@param keymaps AddPackKeymap[]?
local function set_keymaps(keymaps)
	if not keymaps then return end
	for _, km in ipairs(keymaps) do
		local mode = km[1]
		local keymap = km[2]
		local callback = ensure_callback(km[3])
		local desc = km[4]
		vim.keymap.set(mode, keymap, callback, { desc = desc })
	end
end

---@class AddPackSpec
---@field [1]? string Positional source (e.g., "user/repo" or full URL)
---@field src? string Explicit source (e.g., "user/repo" or full URL)
---@field version? string Version specifier (e.g., "1.*", "^2.0", "latest")
---@field opts? table If provided, passed to the plugin's setup function
---@field config? function Function to run after adding the plugin
---@field keys? AddPackKeymap[] List of keymaps to set after adding the plugin

---Helper to call vim.pack.add()
---@param spec AddPackSpec
function AddPack(spec)
	local src = spec.src or spec[1]
	assert(src, "AddPack: table must have a 'src' key or a positional string at [1]")
	if not src:match("^https?://") then
		src = "https://github.com/" .. src
	end
	local pack = { src = src }
	pack.version = spec.version and vim.version.range(spec.version) or nil
	vim.pack.add({ pack })
	if spec.opts then
		local name = src:match("/([^/]+)$")
		name = name and name:gsub("%.git$", ""):gsub("%.n?vim$", "")
		require(name).setup(spec.opts)
	end
	if spec.config then spec.config() end
	set_keymaps(spec.keys)
end

---Helper to set autocommand on plugin update
---@param plugin string
---@param build_callback function
local function build(plugin, build_callback)
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == plugin and kind == "update" then
				if not ev.data.active then vim.cmd.packadd(plugin) end
				build_callback()
			end
		end
	})
end

-- }}}

-- Theme {{{

AddPack {
	"folke/tokyonight.nvim",
	version = "*",
	config = function()
		vim.cmd("colorscheme tokyonight")
	end,
}

-- }}}

-- Oil (file explorer) {{{

AddPack { "nvim-tree/nvim-web-devicons" }
-- AddPack { "nvim-mini/mini.icons.git", opts = {} }
AddPack {
	"stevearc/oil.nvim",
	version = "*",
	opts = { skip_confirm_for_simple_edits = true },
	keys = { { "n", "<leader>pv", vim.cmd.Oil, "Open Oil" } },
}

-- }}}

-- Copilot {{{

AddPack { "github/copilot.vim" }
vim.g.copilot_filetypes = {
	["markdown"] = 1,
}
vim.g.copilot_enabled = false

-- }}}

-- lualine {{{

AddPack { "1478zhcy/lualine-copilot" }
AddPack { "nvim-lualine/lualine.nvim", opts = {
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

AddPack { "rafamadriz/friendly-snippets" }
AddPack { "saghen/blink.cmp", version = "1.*", opts = {} }

-- }}}

-- LSP {{{

AddPack { "neovim/nvim-lspconfig" }

AddPack {
	"folke/lazydev.nvim",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
	config = function()
		vim.lsp.enable("lua_ls")
	end,
}

AddPack {
	"mrcjkb/rustaceanvim",
	version = "^8",
	config = function()
		vim.lsp.enable("rust-analyzer")
	end,
}

-- }}}

-- TODO Comments {{{

AddPack { "nvim-lua/plenary.nvim" }
AddPack { "folke/todo-comments.nvim", opts = {} }

-- }}}

-- Trouble {{{

-- Depends on "nvim-tree/nvim-web-devicons"
AddPack {
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

AddPack { "folke/which-key.nvim", version = "*", opts = {} }
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

AddPack {
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

AddPack {
	"davvid/telescope-git-grep.nvim",
	config = function()
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

AddPack { "nvchad/showkeys" }

-- }}}

-- Git Plugins {{{

AddPack { "sindrets/diffview.nvim" }

AddPack { "https://plugins.ejri.dev/baredot.nvim", opts = { git_dir = "~/.dotfiles" } }

-- Dependencies:
-- "nvim-lua/plenary.nvim",         -- required
-- "sindrets/diffview.nvim",        -- optional - Diff integration

-- Only one of these is needed.
-- "nvim-telescope/telescope.nvim", -- optional
-- "ibhagwan/fzf-lua",              -- optional
-- "echasnovski/mini.pick",         -- optional

-- "ejrichards/baredot.nvim",

AddPack {
	"NeogitOrg/neogit",
	version = "*",
	opts = { graph_style = "kitty" },
	keys = { { "n", "<leader>gs", vim.cmd.Neogit, "Open Neogit status" } },
}

AddPack { "tpope/vim-fugitive" }

AddPack { "lewis6991/gitsigns.nvim", version = "*", opts = {
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

-- AddPack { "MunifTanjim/nui.nvim" }

-- dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },

-- AddPack { "m4xshen/hardtime.nvim", opts = {}, keys = { { "n", "<leader>ht", "Hardtime toggle", "Toggle Hardtime" } } }

-- }}}

-- Cord {{{

build("cord.nvim", function() vim.cmd.Cord("update") end)
AddPack { "vyfor/cord.nvim" }

-- }}}

-- Crates {{{

AddPack { "saecki/crates.nvim", version = "stable", opts = {
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

AddPack { "NMAC427/guess-indent.nvim", opts = {} }

-- }}}

-- hawtkeys (disabled) {{{

-- Dependencies
-- "nvim-lua/plenary.nvim",
-- "nvim-treesitter/nvim-treesitter",

AddPack { "tris203/hawtkeys.nvim" }

-- }}}

-- Treesitter {{{

build("nvim-treesitter", vim.cmd.TSUpdate)

AddPack {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter").install { "rust", "c", "lua", "javascript" }
	end,
}

AddPack { "nvim-treesitter/nvim-treesitter-context" }

-- }}}

-- vim:foldmethod=marker
