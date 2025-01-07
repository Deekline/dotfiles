local ft = { "vue", "html" }

return {
	{
		"MaximilianLloyd/tw-values.nvim",
		opts = {
			focus_preview = true,
		},
		lazy = true,
		ft = ft,
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		opts = {
			color_square_width = 2,
		},
		event = "InsertEnter",
	},
}
