local m = require("util").lazy_map

return {
	"FabijanZulj/blame.nvim",
	config = function()
		require("blame").setup()
	end,
	cmd = { "BlameToggle" },
	keys = {
		m("<leader>gbt", [[BlameToggle]], { desc = "Open Git Blame" }),
	},
}
