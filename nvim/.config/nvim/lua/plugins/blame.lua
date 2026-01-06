return {
	{
		"FabijanZulj/blame.nvim",
		lazy = false,
		cmd = { "BlameToggle" },
		keys = {
			{ "<leader>bt", "<cmd>BlameToggle<CR>", desc = "Blame: toggle" },
		},
		config = function()
			require("blame").setup({})
		end,
		opts = {
			blame_options = { "-w" },
		},
	},
}
