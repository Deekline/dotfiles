return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			-- Choose a preset style for diagnostic appearance
			-- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
			preset = "modern",

			-- Make diagnostic background transparent
			transparent_bg = true,

			-- Make cursorline background transparent for diagnostics
			transparent_cursorline = true,

			options = {
				add_messages = {
					display_count = true,
				},
				multilines = {
					enabled = true,
				},
			},
		})
		vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
	end,
}
