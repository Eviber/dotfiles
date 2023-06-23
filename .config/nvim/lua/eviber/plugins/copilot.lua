return {
	'github/copilot.vim',
	event = 'VeryLazy',
	config = function()
		vim.g.copilot_filetypes = {
			['markdown'] = 1,
		}
		-- vim.g.copilot_assume_mapped = true
	end,
}
-- use {
-- 	"zbirenbaum/copilot.lua",
-- 	cmd = "Copilot",
-- 	config = function()
-- 		require("copilot").setup({
-- 			panel = {
-- 				enabled = false,
-- 				auto_refresh = true,
-- 			},
-- 			suggestion = {
-- 				enabled = true,
-- 				auto_trigger = true,
-- 				keymap = {
-- 					-- accept = "<Tab>",
-- 				},
-- 			},
-- 			filetypes = {
-- 				markdown = true,
-- 				yaml = true,
-- 			},
-- 		})
-- 	end,
-- }
