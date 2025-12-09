local copilot = {
	'github/copilot.vim',
	event = 'VeryLazy',
	config = function()
		vim.g.copilot_filetypes = {
			['markdown'] = 1,
		}

		-- toggle Copilot
		vim.api.nvim_create_user_command('CopilotToggle', function()
			vim.g.copilot_enabled = not vim.g.copilot_enabled
			if vim.g.copilot_enabled then
				vim.cmd('Copilot disable')
			else
				vim.cmd('Copilot enable')
			end
		end, {nargs = 0})


		-- vim.g.copilot_assume_mapped = true
	end,
   -- keys = {
		-- { '<leader>c', '<cmd>CopilotToggle<CR>', desc = 'Toggle Copilot' },
   -- },
}

return copilot

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
