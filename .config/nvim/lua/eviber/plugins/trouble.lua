local function toggle_quickfix()
	require("trouble").toggle("quickfix")
end

return {
	"folke/trouble.nvim",
	cmd = {
		"Trouble",
		"TroubleRefresh",
		"TroubleToggle",
	},
	keys = {
		{ "<leader>tt", toggle_quickfix, desc = "Toggle Trouble Quickfix" },
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = {
	},
}
