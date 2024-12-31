local t = require("util.toggle")
local u = require("util")
local m = u.lazy_map
local opts = t.toggleterm_opts
local modes = { "n", "t" }

return {
	"akinsho/toggleterm.nvim",
	opts = opts,
	event = "VeryLazy",
	version = "*",
	keys = {
		m("[1", "ToggleTermLazyGit", modes),
	},
	branch = "main",
}
