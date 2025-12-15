local copilot = {
	'github/copilot.vim',
	event = 'VeryLazy',
	config = function()
		vim.g.copilot_filetypes = {
			['markdown'] = 1,
		}

		local copilot_enabled = false
		-- toggle Copilot
		vim.api.nvim_create_user_command('CopilotToggle', function()
			if copilot_enabled ~= true then
				copilot_enabled = true
			else
				copilot_enabled = false
			end
			if copilot_enabled == true then
				vim.cmd('Copilot disable')
			else
				vim.cmd('Copilot enable')
			end
		end, {nargs = 0})


		-- vim.g.copilot_assume_mapped = true
		-- vim.cmd('Copilot status')
		vim.cmd('Copilot disable')
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
